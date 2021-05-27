#tool
extends Control
class_name NewGraphEdit


export(Array, NodePath) var node_templates := []
export(Array, Array) var connection_types := []# [[color: Color, button_left: Button, button_right: Button], ···]
export(StyleBox) var background_style

var nodes := {}# {id: [path, template], ···}
var last_id := 0
var view_rect: Rect2 = Rect2(Vector2.ZERO, Vector2.ONE)
var world_rect: Rect2 = Rect2(-rect_size, rect_size * 2)
var toolbox: HBoxContainer
var h_scroll_bar: HScrollBar
var v_scroll_bar: VScrollBar

signal node_added(node_id)
signal node_edited(node_id)
signal node_removed(node_id)


func _ready() -> void:
	rect_clip_content = true

	h_scroll_bar = HScrollBar.new()
	h_scroll_bar.anchor_top = 1.0
	h_scroll_bar.anchor_right = 1.0
	h_scroll_bar.anchor_bottom = 1.0
	h_scroll_bar.grow_vertical = GROW_DIRECTION_BEGIN
	add_child(h_scroll_bar)

	v_scroll_bar = VScrollBar.new()
	v_scroll_bar.anchor_left = 1.0
	v_scroll_bar.anchor_right = 1.0
	v_scroll_bar.anchor_bottom = 1.0
	v_scroll_bar.grow_horizontal = GROW_DIRECTION_BEGIN
	add_child(v_scroll_bar)

	toolbox = HBoxContainer.new()
	toolbox.anchor_right = 1.0
	add_child(toolbox)


func _draw() -> void:
	draw_style_box(background_style, Rect2(Vector2.ZERO, rect_size).grow(-1))

	world_rect = Rect2(-rect_size, rect_size * 2)

	h_scroll_bar.margin_right = -v_scroll_bar.rect_size.x
	v_scroll_bar.margin_bottom = -h_scroll_bar.rect_size.y

	h_scroll_bar.page = view_rect.size.x * rect_size.x
	v_scroll_bar.page = view_rect.size.y * rect_size.y

	h_scroll_bar.min_value = world_rect.position.x
	v_scroll_bar.min_value = world_rect.position.y

	h_scroll_bar.max_value = world_rect.end.x
	v_scroll_bar.max_value = world_rect.end.y


func zoom(amount: Vector2, coords: Vector2) -> void:
	view_rect.position += (Vector2(-0.5, -0.5) + coords) * (view_rect.size * amount - view_rect.size)
	view_rect.size *= amount
