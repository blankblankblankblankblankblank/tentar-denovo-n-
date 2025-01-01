extends Node3D
var twink = create_tween()
@onready var sprite = get_node('Sprite3D')

func _ready() -> void:
	twink.tween_property(sprite,'modulate',Color(1,1,1,0),1.8)
	twink.parallel().tween_property(sprite,'scale',Vector3(1.8,1.8,1.8),1.8)
	twink.tween_interval(4.2)
	twink.tween_callback(queue_free)
