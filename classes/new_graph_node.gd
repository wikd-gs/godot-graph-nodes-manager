#tool
extends Container
class_name NewGraphNode


export(Array, Array) var ports := []# [[type_left: int, type_right: int, v_offset: float], ···]
export(Array, Texture) var custom_textures := []


func make_from(node) -> int:
	if node is NewGraphNode:
		push_error("Sorry, making this node from another one is not supported here, use duplicate() instead")

	elif node is HBoxContainer:
		pass

	return OK
