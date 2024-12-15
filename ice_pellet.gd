extends Area3D
var twink = create_tween()
var caster:NodePath
var dmg = 11
var speed = 38

@onready var mod = get_node('MeshInstance3D')

func _ready() -> void:
	twink.tween_interval(2.1)
	twink.tween_callback(queue_free)

func _physics_process(delta: float) -> void:
	position += transform.basis.z * -speed * delta

func _on_body_entered(hit):
	if hit != get_node(caster):
		if hit.is_in_group('jogador'):
			hit._on_hit.rpc(dmg)
			get_node(caster).hit_mark()
		queue_free()
