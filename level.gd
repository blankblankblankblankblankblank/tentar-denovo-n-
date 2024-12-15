extends Node3D

const SPAWN_RANDOM := 5.0

# raio = 0
const shots = [preload('res://raio.tscn'),preload('res://fireball.tscn'),preload('res://shotsfired.tscn')]

const explo = preload('res://explosion.tscn')
@export var spawn_positions := []
@onready var worldsync = get_node('WorldSync')

var spread = [Vector3.ZERO,Vector3(1,1,0),Vector3(1,-1,0),Vector3(-1,1,0),Vector3(-1,-1,0)]

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	# We only need to spawn players on the server.
	if not multiplayer.is_server():
		return

	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)

	# Spawn already connected players.
	for id in multiplayer.get_peers():
		add_player(id)
	
	# Spawn the local player unless this is a dedicated server export.
	if !DisplayServer.get_name() == "headless" and multiplayer.is_server():
		add_player(1)

@rpc("call_local",'authority')
func die(path):
	get_node(path).hp = 200
	get_node(path).position = get_node(spawn_positions.pick_random()).global_position

func _exit_tree():
	if not multiplayer.is_server(): 
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)


func add_player(id: int):
	var character = load("res://jogador.tscn").instantiate()
	# Set player id.
	character.player = id
	#Randomize character position.
	character.position = get_node(spawn_positions.pick_random()).global_position
	character.name = str(id)
	add_child(character, true)
	character.player = id

func del_player(id: int):
	var player = get_node_or_null(str(id))
	if player != null:
		get_node(str(id)).queue_free()

@rpc('call_local')
func add_shot(parent_way:NodePath,shot:int):
	match shot:
		0:
			var r = shots[shot].instantiate()
			r.name = str(randi_range(0, 1024))
			r.caster = parent_way
			r.position = get_node(parent_way).get_node('Camera/Marker3D').global_position
			r.rotation = get_node(parent_way).get_node('Camera').global_rotation
			add_child(r,true)
		1:
			var r = shots[shot].instantiate()
			r.name = str(randi_range(0, 1024))
			r.caster = parent_way
			#r.get_node('modelo').position = get_parent().get_node('Marker3D').position - get_parent().get_node('Camera3D').position + Vector3(0,0,-250)
			r.position = get_node(parent_way).get_node('Camera/Marker3D').global_position
			r.rotation = get_node(parent_way).get_node('Camera').global_rotation
			add_child(r,true)
			r.apply_central_impulse(-(get_node(parent_way).get_node('Camera').global_transform.basis.z) * 90)
		2:
			var r = shots[shot].instantiate()
			r.name = str(randi_range(0, 3900))
			r.caster = parent_way
			r.position = get_node(parent_way).get_node('Camera/Marker3D').global_position
			rng.randomize()
			var cam = get_node(parent_way).get_node('Camera')
			r.rotation_degrees = cam.global_rotation_degrees
			add_child(r,true)
		#2:
			#for i in 5:
				#var r = shots[shot].instantiate()
				#r.name = str(randi_range(0, 3900))
				#r.caster = parent_way
				#r.position = get_node(parent_way).get_node('Camera/Marker3D').global_position
				#rng.randomize()
				#var cam = get_node(parent_way).get_node('Camera')
				#r.rotation_degrees = cam.global_rotation_degrees
				#if i:
					#var div2 = ((2*(i%2)-1))
					#r.rotation_degrees += Vector3(0,div2*i/3.0,0)
				#add_child(r,true)

func _explode(pos:Vector3):
	var r = explo.instantiate()
	r.position = pos
	add_child(r,true)
