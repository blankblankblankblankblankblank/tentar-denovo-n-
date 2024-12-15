@tool
extends Sprite3D

func _process(delta: float) -> void:
	rotation.y += 1.2*delta
