#tool
extends Container
class_name NewGraphNode, "res://addons/graph-manager/classes/new_graph_node_icon.svg"


export(Array, Resource) var ports := [] setget set_ports
export(Array, Texture) var custom_textures := []
export var node_rect: Rect2 = Rect2(Vector2.ZERO, Vector2(100, 100)) setget set_node_rect
export var selected := false setget set_selected

var content: Node setget set_content
var id

signal node_rect_updated(node_from)


func set_ports(new_value: Array) -> void:
	for new_port_idx in new_value.size():
		if new_value[new_port_idx] is NewGraphPort:

			if not new_value[new_port_idx].followed_node is Control:
				if new_value[new_port_idx].followed_node_path:
					if get_node(new_value[new_port_idx].followed_node_path) is Control:
						new_value[new_port_idx].followed_node = get_node(new_value[new_port_idx].followed_node_path)

					else:
						push_error("Tried to find a node to follow at %s, but we didn't found a Control-derived one!")

				else:
					new_value[new_port_idx].followed_node = self

		else:
			new_value[new_port_idx] = NewGraphPort.new()

	ports = new_value

	return


func set_node_rect(new_value: Rect2) -> void:
	node_rect = new_value
	node_rect.size.x = max(node_rect.size.x, 0)
	node_rect.size.y = max(node_rect.size.y, 0)

	emit_signal("node_rect_updated", self)


func set_content(new_value: Node) -> void:
	if content and content != new_value:
		new_value.get_parent().remove_child(new_value)
		var content_parent_path: NodePath = get_path_to(content.get_parent())

		content.queue_free()

		get_node(content_parent_path).add_child(new_value)

	else:
		content = new_value


func set_selected(new_value: bool) -> void:
	selected = new_value
