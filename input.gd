extends MultiplayerSynchronizer

@export_category('mp')
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
@onready var timers = [get_parent().get_node('armas/1'),
						get_parent().get_node('armas/2'),
						get_parent().get_node('armas/3')]
@onready var cam = get_parent().get_node('Camera')

func _enter_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	%Camera.current = is_multiplayer_authority()
	%Camera/HandMesh.visible = is_multiplayer_authority()
	set_process(is_multiplayer_authority())
	set_process_input(is_multiplayer_authority())
	#set_process(get_multiplayer_authority() == get_parent().player)
	#set_process_input(get_multiplayer_authority() == get_parent().player)

func _ready() -> void:
	var _load = FileAccess.open("user://ScumOfTheEarth.save", FileAccess.READ).get_line()
	var jason = JSON.new()
	jason.parse(_load)
	get_parent().data = jason.data
	if %Camera/HandMesh.visible:
		%Camera/HandMesh/animplayer.play("hand/default")

func _config_altered():
	sense = Config.get_config('InputSettings','MouseSensitivity',0.2)
	%Camera.fov = Config.get_config('VideoSettings','FieldOfView',90)
	%Camera/HandMesh.position.x = Config.get_config('VideoSettings','HandPosition',1)*0.2
	if %Camera/HandMesh.position.x < 0:
		%Camera/HandMesh.scale.z = -0.035
	else:
		%Camera/HandMesh.scale.z = 0.035

@rpc("call_local")
func jump():
	jumping = true
	$JumpTimer.start()

func _process(_delta):
	if !Options.visible:
		if is_multiplayer_authority():
			direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
			if Input.is_action_just_pressed("jump"):
				jump.rpc()
			if Input.is_action_just_pressed('MouseOne'):
				shoot.rpc()
#
@rpc('call_local')
func shoot():
	if timers[arma].is_stopped():
		get_parent().get_parent().add_shot(get_parent().get_path(),arma)
		timers[arma].start()
		%Camera/HandMesh/animplayer.play("hand/shoot")

func _input(event):
	if event.is_action_pressed('ui_text_clear_carets_and_selection'):
		_config_altered()
	if !Options.visible:
		if event is InputEventMouseMotion:
			get_parent().rotate_y(deg_to_rad(-event.relative.x * sense))
			cam.rotate_x(deg_to_rad(-event.relative.y * sense))
			cam.rotation.x = clamp(cam.rotation.x, -PI/2, PI/2)
			cam_rot = cam.rotation
			rot = get_parent().rotation
			get_parent().rotate_rpc.rpc(cam_rot,rot,get_parent().get_path())
		if event is InputEventKey:
			if int(OS.get_keycode_string(event.key_label)) != 0:
				print(OS.get_keycode_string(event.key_label))
				arma = int(OS.get_keycode_string(event.key_label))-1

func _on_jump_timer_timeout() -> void:
	jumping = false

func _on_animplayer_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'hand/shoot':
		%Camera/HandMesh/animplayer.play("hand/default")
