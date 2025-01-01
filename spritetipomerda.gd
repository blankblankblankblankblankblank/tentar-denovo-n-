@tool
extends Sprite3D
@export var rotation_scale:Vector3
@export var rotation_rate:float

func _process(delta: float) -> void:
	rotation += rotation_rate * delta * rotation_scale
