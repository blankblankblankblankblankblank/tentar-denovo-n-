extends Node3D
var twink = create_tween()
@onready var sprite = get_node('Sprite3D')
var meat = preload('res://Meat.tscn')

func spawn_meat():
	var inst = meat.instantiate()
	inst.position = Vector3(0,0.3,0)
	inst.apply_central_impulse(Vector3(randf_range(-1,1),randf_range(0,1),randf_range(-1,1)))
	add_child(inst)

func _ready() -> void:
	for i in 3:
		spawn_meat()
	twink.tween_property(sprite,'modulate',Color(1,1,1,0),1.8)
	twink.parallel().tween_property(sprite,'scale',Vector3(1.8,1.8,1.8),1.8)
	twink.tween_interval(120)
	twink.tween_callback(queue_free)
