extends MultiplayerSynchronizer

@export var jumping := false;
@export var direction := Vector2();
@export var cam_rot := Vector3();
@export var rot := Vector3();
var sense = 0.2;

@export var arma = 0

#the timers are numbered for the weaponds they represent
#0 - raio
#1 - fireball
#2 - ice shotgun

func _enter_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	%Camera.current = is_multiplayer_authority()
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
	#set_process(get_multiplayer_authority() == get_parent().player)
	#set_process_input(get_multiplayer_authority() == get_parent().player)

@rpc("call_local")
func jump():
	jumping = true

func _process(_delta):
	if is_multiplayer_authority():
		direction = Input.get_vector("a", "d", "w", "s")
		if Input.is_action_just_pressed("ui_accept"):
			jump.rpc()
		#if Input.is_action_just_pressed('MouseOne'):
			#shoot()
	#else:
		#direction = Input.get_vector("a", "d", "w", "s")
		#if Input.is_action_just_pressed("jump"):
			#jump.rpc()
		#if Input.is_action_just_pressed('MouseOne'):
			#shoot.rpc()
#
#@rpc('call_remote')
#func shoot():
	#if timers[arma].is_stopped():
		#get_parent().get_parent().add_shot(get_parent().player,get_parent().get_path(),arma)
		#timers[arma].start()

func _input(event):
	if event is InputEventMouseMotion:
		get_parent().rotate_y(deg_to_rad(-event.relative.x * sense))
		%Camera.rotate_x(deg_to_rad(-event.relative.y * sense))
		%Camera.rotation.x = clamp(%Camera.rotation.x, -PI/2, PI/2)
		cam_rot = %Camera.rotation
		rot = get_parent().rotation
	if event is InputEventKey:
		if int(OS.get_keycode_string(event.key_label)) != 0:
			print(OS.get_keycode_string(event.key_label))
			arma = int(OS.get_keycode_string(event.key_label))-1

func _on_jump_timer_timeout() -> void:
	jumping = false
