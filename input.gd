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

var preload_textures = [preload('res://textures/ShotOne.png'),preload('res://textures/ShotTwo.png'),preload('res://textures/ShotThree.png')]

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
	#adiciona as informações a um array no level
	#get_parent().get_parent().path_and_name.append([get_parent().get_path(),jason.data[1]])
	if %Camera/HandMesh.visible:
		%Camera/HandMesh/animplayer.play("hand/default")
	_config_altered()

func _config_altered():
	#sensibilidade
	sense = Config.get_config('InputSettings','MouseSensitivity',0.2)
	#fov da camera
	%Camera.fov = Config.get_config('VideoSettings','FieldOfView',90)
	get_parent().fov = Config.get_config('VideoSettings','FieldOfView',90)
	#posição da mão
	%Camera/HandMesh.position.x = Config.get_config('VideoSettings','HandPosition',1)*0.2
	#FPS e FrameTime
	%Control/FPS.visible = Config.get_config('GameSettings','ShowFps',false)
	%Control/FrameTime.visible = Config.get_config('GameSettings','ShowFrameTime',false)
	#qualidade das luzes
	var lights = (Config.get_config('VideoSettings','ShadingMode',0)!=1)
	%Camera.set_cull_mask_value(3,lights)
	#visiblidade quando trocando de armas
	%Camera.get_node('HandMesh/Sprite3D').visible = Config.get_config('GameSettings','ShowWeaponSwitch',true)
	%Camera.get_node('HandMesh/Sprite3D2').visible = Config.get_config('GameSettings','ShowWeaponSwitch',true)
	if Config.get_config('VideoSettings','ShadingMode',0) == 2:
		%Camera.environment = load('res://SDFGI_enviroment_'+str(get_parent().get_parent().level)+'.tres')
	else:
		%Camera.environment = null
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
		if %Control/FPS.visible:
			%Control/FPS.text = 'FPS:'+str(Engine.get_frames_per_second())
		if %Control/FrameTime.visible:
			%Control/FrameTime.text = 'Frame Time:' +str(100.0*(RenderingServer.viewport_get_measured_render_time_cpu(get_tree().root.get_viewport_rid())
			+RenderingServer.get_frame_setup_time_cpu()))+'ms'
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
		if event.is_action_pressed('1'):
			arma = 0
			switch_weapons_animation()
		elif event.is_action_pressed('2'):
			arma = 1
			switch_weapons_animation()
		elif event.is_action_pressed('3'):
			arma = 2
			switch_weapons_animation()
		
#		foi bom equanto durou
		#if event is InputEventKey:
			#if int(OS.get_keycode_string(event.key_label)) != 0:
				#print(OS.get_keycode_string(event.key_label))
				#arma = int(OS.get_keycode_string(event.key_label))-1
		
		#Players Tab
		if Input.is_action_pressed('TAB'):
			%Control/VBoxContainer.visible = true
			%Control/Panel.visible = true
			%Control/VBoxContainer._update()
		else:
			%Control/VBoxContainer.visible = false
			%Control/Panel.visible = false

func switch_weapons_animation() -> void:
	%Camera.get_node('HandMesh/Sprite3D2').texture = preload_textures[arma]
	%Camera.get_node('HandMesh/SpellAnimator').play('Switch')

func _on_jump_timer_timeout() -> void:
	jumping = false

func _on_animplayer_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'hand/shoot':
		%Camera/HandMesh/animplayer.play("hand/default")
