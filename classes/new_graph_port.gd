#tool
extends Resource
class_name NewGraphPort, "res://addons/graph-manager/classes/new_graph_port_icon.svg"


# Type of the left connection, -1 means hidden
export var type_left := 0

# Type of the right connection, -1 means hidden
export var type_right := 0

# The vertical offset of the connection, if there's a followed node it's realtive to the node's aligned position, if there isn't it's relative to the NewGraphNode's top
export var v_offset := 0.0

# The followed node's path, position updates must (and will) be mandled by the NewGraphNode
export var followed_node: NodePath

# The connection alignment relative to the followed_node (or NewGraphNode)'s rect
export var followed_node_align := 0.0
