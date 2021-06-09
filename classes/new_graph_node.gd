#tool
extends Container
class_name NewGraphNode, "res://addons/graph-manager/classes/new_graph_node_icon.svg"


export(Array, Resource) var ports := [] setget set_ports
export(Array, Texture) var custom_textures := []
export var node_rect: Rect2 = Rect2(Vector2.ZERO, Vector2(100, 100)) setget set_node_rect

var content_container: Control
var selected := false setget set_selected

var id


signal node_rect_updated(node_from)


func set_ports(new_value: Array) -> void:
	for new_port_idx in new_value.size():
		if not new_value[new_port_idx] is NewGraphPort:
			new_value[new_port_idx] = NewGraphPort.new()

	ports = new_value

	return


func set_node_rect(new_value: Rect2) -> void:
	node_rect = new_value
	emit_signal("node_rect_updated", self)


func set_selected(new_value: bool) -> void:
	selected = new_value
