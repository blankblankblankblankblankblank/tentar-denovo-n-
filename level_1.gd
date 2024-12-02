extends Node3D
var player = preload("res://jogador.tscn")

func _ready() -> void:
	randomize()
	var pl = player.instantiate()
	call_deferred("add_child",pl)
	pl.postion = get_node('Elements/Spawnpoits/Marker3D'+str(randi_range(1,12))).position
