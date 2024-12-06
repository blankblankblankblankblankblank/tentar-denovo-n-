extends Area3D
var dmg = 18
var impulse = 40

@onready var albedo = get_node('MeshInstance3D').get_active_material(0)
@onready var parti := get_node('GPUParticles3D')
@onready var anim := get_node('AnimationPlayer')
@onready var twink = create_tween()

func _ready():
	parti.emitting = true
	anim.play('explosion')
	albedo.albedo_color.a = 1
	twink.tween_property(albedo,'albedo_color',Color(1,1,1,0),0.7)

func _on_timer_timeout():
	call_deferred('queue_free')

func _on_body_entered(hit):
	if hit.is_in_group('jogador'):
		var dist = position.distance_squared_to(hit.position)
		var dir = position.direction_to(hit.position)
		hit.Velocity += dir * (impulse - dist)
		hit._on_hit(max( dmg - dist*0.55 ,1))
