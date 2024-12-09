extends RigidBody3D
var caster:NodePath
var dmg = 22

@onready var explo = preload("res://explosion.tscn")
@onready var mod = get_node('MeshInstance3D')
var twink = create_tween()

func _ready() -> void:
	twink.tween_interval(1)
	twink.tween_callback(_explosion)

func _explosion():
	get_parent()._explode(position)
	queue_free()

func _on_body_entered(hit):
	if hit != get_node(caster):
		linear_velocity *= 0.35
		if hit.is_in_group('jogador'):
			hit._on_hit.rpc(dmg)
			get_node(caster).hit_mark()
			_explosion()
