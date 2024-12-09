extends RayCast3D
var caster:NodePath
var dmg = 20
@onready var mesh2 = get_node('MeshInstance3D2')

func _ready() -> void:
	var tuin = create_tween()
	tuin.set_ease(Tween.EASE_OUT_IN)
	tuin.set_trans(Tween.TRANS_CIRC)
	tuin.tween_property(self,'scale',Vector3.ZERO,0.25)
	tuin.tween_callback(queue_free)

func _physics_process(_delta: float) -> void:
	if is_colliding():
		var hit = get_collider()
		if hit.is_in_group('jogador') and hit != get_node(caster):
			hit._on_hit.rpc(dmg)
			get_node(caster).hit_mark()
		enabled = false
		var colpoint = to_local(get_collision_point())
		mesh2.position.z = colpoint.z/2
		mesh2.mesh.height = colpoint.z
