#tool
extends Control
class_name NewGraphEdit, "res://addons/graph-manager/classes/new_graph_edit_icon.svg"


export(Array, Array) var connection_types := [] # [[color: Color, button_left: Button, button_right: Button], ···]
export(StyleBox) var background_style
export var scrollbar_margin := 2.0
export var world_min_size := Vector2(400, 400)

var nodes := {}# {id: [path, metadata], ···}
var last_id := 0
var view_rect: Rect2 = Rect2(Vector2.ZERO, Vector2.ONE)
var world_rect: Rect2 = Rect2(-rect_size, rect_size * 2)
var toolbox: HBoxContainer
var h_scroll_bar: HScrollBar
var v_scroll_bar: VScrollBar

signal node_added(node_id)
#signal node_changed(node_id)
signal node_removed(node_id)


func _ready() -> void:
	rect_clip_content = true

	h_scroll_bar = HScrollBar.new()
	h_scroll_bar.anchor_top = 1.0
	h_scroll_bar.anchor_right = 1.0
	h_scroll_bar.anchor_bottom = 1.0
	h_scroll_bar.grow_vertical = GROW_DIRECTION_BEGIN
	add_child(h_scroll_bar)

	#warning-ignore: RETURN_VALUE_DISCARDED :P
	h_scroll_bar.connect("scrolling", self, "update_scroll")

	v_scroll_bar = VScrollBar.new()
	v_scroll_bar.anchor_left = 1.0
	v_scroll_bar.anchor_right = 1.0
	v_scroll_bar.anchor_bottom = 1.0
	v_scroll_bar.grow_horizontal = GROW_DIRECTION_BEGIN
	add_child(v_scroll_bar)

	#warning-ignore: RETURN_VALUE_DISCARDED :P
	v_scroll_bar.connect("scrolling", self, "update_scroll")

	toolbox = HBoxContainer.new()
	toolbox.anchor_right = 1.0
	add_child(toolbox)

	for child in get_children():
		if child is NewGraphNode:
			add_node(child, ["original_children"])
			child.node_rect = Rect2(child.rect_position, child.rect_size)

	#warning-ignore: RETURN_VALUE_DISCARDED :P
	connect("resized", self, "update_scroll")


func _draw() -> void:
	draw_style_box(background_style, Rect2(Vector2.ZERO, rect_size).grow(-1))

	world_rect = Rect2(Vector2.ZERO, Vector2.ZERO)

	for node_id in nodes.keys():
		var node = get_node(nodes[node_id][0] as NodePath)

		if node != null and node is NewGraphNode:
			node.rect_position = node.node_rect.position / view_rect.size - view_rect.position
			node.rect_size = node.node_rect.size
			node.rect_scale = Vector2.ONE / view_rect.size

			world_rect = world_rect.merge(node.node_rect)

		else:
			push_error("Getting node from id %s failed, idk why ¯\\_(ツ)_/¯" % node_id)

	world_rect = world_rect.grow_margin(MARGIN_LEFT, world_min_size.x / view_rect.size.x)
	world_rect = world_rect.grow_margin(MARGIN_RIGHT, world_min_size.x / view_rect.size.x)
	world_rect = world_rect.grow_margin(MARGIN_TOP, world_min_size.y / view_rect.size.y)
	world_rect = world_rect.grow_margin(MARGIN_BOTTOM, world_min_size.y / view_rect.size.y)

	h_scroll_bar.margin_right = -v_scroll_bar.rect_size.x - scrollbar_margin * 2
	v_scroll_bar.margin_bottom = -h_scroll_bar.rect_size.y - scrollbar_margin * 2

	h_scroll_bar.margin_bottom = -scrollbar_margin
	v_scroll_bar.margin_right = -scrollbar_margin

	h_scroll_bar.margin_left = scrollbar_margin
	v_scroll_bar.margin_top = scrollbar_margin

	h_scroll_bar.page = view_rect.size.x * rect_size.x
	v_scroll_bar.page = view_rect.size.y * rect_size.y

	h_scroll_bar.min_value = world_rect.position.x
	v_scroll_bar.min_value = world_rect.position.y

	h_scroll_bar.max_value = world_rect.end.x
	v_scroll_bar.max_value = world_rect.end.y


func update_scroll() -> void:
	var new_scroll = Vector2(h_scroll_bar.value, v_scroll_bar.value)

	view_rect.position = new_scroll

	update()


func add_node(node_from: NewGraphNode, custom_metadata := [], custom_id = null):
	if node_from.get_parent() == self:
		pass

	elif node_from.get_parent() == null:
		add_child(node_from)

	else:
		node_from.get_parent().remove_child(node_from)
		add_child(node_from)

	if custom_id:
		if nodes.has(custom_id):
			push_error("Looks like this custom id (%s) is already taken, be sure to anihiliate the old node or to choose another id!" % custom_id)
			return

		else:
			var node_content := [node_from.get_path()]
			node_content.append_array(custom_metadata)
			nodes[custom_id] = node_content

			node_from.id = custom_id

			emit_signal("node_added", custom_id)

			return custom_id

	else:
		var node_content := [node_from.get_path()]
		node_content.append_array(custom_metadata)
		nodes[last_id] = node_content

		node_from.id = last_id

		emit_signal("node_added", last_id)

		last_id += 1

		return last_id - 1


func remove_node(node_id) -> void:
	if nodes.has(node_id):
		var node = get_node(nodes[node_id][0] as NodePath)

		node.queue_free()

		var err = nodes.erase(node_id)
		if err:
			emit_signal("node_removed", node_id)

		else:
			push_error("Tried to delete a key in the nodes dictionary, but I failed! (error code: %s)" % err)

	else:
		push_error("Tried to delete a node with the id %s, but I found nothing!" % node_id)


func zoom(amount: Vector2, realtive_coords: Vector2) -> void:
	view_rect.position += (Vector2(-0.5, -0.5) + realtive_coords) * (view_rect.size * amount - view_rect.size)
	view_rect.size *= amount
