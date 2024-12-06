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
	if hit.is_in_group('jogador'):
		if hit != get_node(caster):
			hit._on_hit(dmg)
			hit.hit_mark.rpc_id(get_node(caster).player)
			_explosion()
