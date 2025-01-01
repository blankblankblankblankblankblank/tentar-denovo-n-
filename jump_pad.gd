extends Node3D
@export var JumpStrengh := 75

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group('jogador'):
		body.Velocity.y = clamp(body.Velocity.y+JumpStrengh,JumpStrengh-10,JumpStrengh)
