extends Node3D
var twink = create_tween()
var caster : NodePath

func _ready() -> void:
	for i in get_children():
		i.caster = caster
	twink.tween_interval(2.5)
	twink.tween_callback(queue_free)
