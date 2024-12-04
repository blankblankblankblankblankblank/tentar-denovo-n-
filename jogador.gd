extends CharacterBody3D
#vars
const JUMP_VELOCITY = 12.0
var BASVEL = 18.0
const MAXVEL = 22.0
const MINVEL = 18.0
var accel := 24.0
var friction := 5.0

var gravity = 56

#stats
@export var hp = 200
@export var Velocity : Vector3

#ui
#@onready var progress = $Control/ProgressBar
#@onready var label = $Control/ProgressBar/Label
#@onready var speedl = $Control/speed
@onready var cam = $Camera
@onready var nick:String

# Set by the authority, synchronized on spawn.
@export var player := 1:
	set(id):
		player = id
		%Input.set_multiplayer_authority(id)

# Player synchronized input.
@onready var input = get_node('Input')

func _ready() -> void:
	get_node('PlayerSync').set_visibility_for(player,false)

@rpc ("call_remote","any_peer")
func rotate_rpc(camr:Vector3,rot:Vector3,path:NodePath):
	if player != multiplayer.get_unique_id():
#		get_node(path).cam.rotation = camr
#		get_node(path).rotation = rot
#		mesma coisa tipo merda... só que melhor
		get_node(path).cam.rotation.x = lerp_angle(get_node(path).cam.rotation.x,camr.x,0.7)
		get_node(path).rotation.y = lerp_angle(get_node(path).rotation.y,rot.y,0.7)

func _process(delta):
	rotate_rpc.rpc(cam.rotation,rotation,get_path())
	var direction = transform.basis * (Vector3(input.direction.x, 0, input.direction.y)).normalized()
	if direction:
		Velocity = _accelerate(accel,direction,delta)
	
	BASVEL = MINVEL
	if !is_on_floor():
		BASVEL = MAXVEL
		Velocity.y -= gravity * delta
	else:
		Velocity = _friction(delta)
	if input.jumping and is_on_floor():
		Velocity.y = JUMP_VELOCITY
	velocity = Velocity
	move_and_slide()

func _accelerate(accele : float, dir : Vector3, delta : float) -> Vector3:
	var current_speed: float = Velocity.dot(dir.normalized())
	var add_speed: float = clamp(BASVEL - current_speed, 0, accele * 3.25 * delta)
	return Velocity + (dir * add_speed)

func _friction(delta: float) -> Vector3:
	var speed: float = Velocity.length_squared()
	var scaled_velocity: Vector3
	if speed != 0:
		var drop = speed * friction * delta
		scaled_velocity = Velocity * max(speed - drop, 0) / speed
	else:
		return Velocity * 0.1
	return scaled_velocity

@rpc ("call_local")
func _on_hit(dmg:int):
	hp -= dmg
	print(str(player)+': HP '+str(hp))
