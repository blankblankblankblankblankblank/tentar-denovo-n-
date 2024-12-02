extends Button
class_name Buttontipomerda
var resetScale = Vector2.ONE
var shake = self.create_tween()

func _ready():
	randomize()
	shake.set_loops()
	shake.stop()
	shake.set_ease(Tween.EASE_IN)
	shake.set_trans(Tween.TRANS_SPRING)
	resetScale = scale
	self.mouse_entered.connect(_expand)
	self.mouse_exited.connect(_shrink)

func _expand():
	shake.play()
	shake.tween_property(self,'rotation_degrees',4.5,0.3 + randf_range(-0.12,0.27))
	shake.parallel().tween_property(self,'scale',resetScale * 1.275,0.2 + randf_range(-0.21,0.26))
	shake.tween_property(self,'rotation_degrees',-4.5,0.3 + randf_range(-0.2,0.2))
	shake.parallel().tween_property(self,'scale',resetScale * 1.125,0.2 + randf_range(-0.23,0.12))
	var twink = self.create_tween()
	twink.set_ease(Tween.EASE_OUT)
	twink.set_trans(Tween.TRANS_ELASTIC)
	twink.tween_property(self,'scale',resetScale * 1.225,0.2)

func _shrink():
	shake.stop()
	rotation_degrees = 0
	var twink = self.create_tween()
	twink.tween_property(self,'scale',resetScale ,0.2)
