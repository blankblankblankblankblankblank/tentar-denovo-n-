@tool
extends MeshInstance3D
const default_text = preload('res://exports/textures/handtexture.png')
const shooting_text = preload('res://exports/textures/handtexture_shooting.png')
#STATES: 0 - normal 1 - shooting
@export var ALBEDO = "res://exports/textures/handtexture.png":
	set(text):
		ALBEDO = text
		get_active_material(0).albedo_texture = load(text)
