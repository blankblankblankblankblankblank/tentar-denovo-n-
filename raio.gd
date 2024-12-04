extends RayCast3D
var caster:NodePath
var dmg = 20

func _ready() -> void:
	var tuin = create_tween()
	tuin.set_ease(Tween.EASE_IN)
	tuin.set_trans(Tween.TRANS_QUART)
	tuin.tween_property(self,'scale',Vector3.ZERO,0.25)
	tuin.tween_callback(queue_free)

func _physics_process(_delta: float) -> void:
	if is_colliding():
		var hit = get_collider()
		if hit.is_in_group('jogador') and !hit == get_node(caster):
			hit._on_hit.rpc(dmg)
