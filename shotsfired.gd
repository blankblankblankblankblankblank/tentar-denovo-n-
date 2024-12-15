extends Node3D
var caster : NodePath

func _ready() -> void:
	for i in get_children():
		i.caster = caster
