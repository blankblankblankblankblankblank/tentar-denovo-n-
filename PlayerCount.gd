extends VBoxContainer
@onready var list = multiplayer.get_peers()

func _update():
	for i in get_children():
		i.queue_free()
	list = multiplayer.get_peers()
	for i in get_tree().get_nodes_in_group("jogador"):
		var n = Label.new()
		n.text = i.get_node('MeshInstance3D/Label3D').text
		n.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(n)
