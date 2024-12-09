extends MasterOptionsMenu
var cor := Color(1,1,1)
var nick := 'Bobão'

func _ready():
	set_multiplayer_authority(multiplayer.get_unique_id())

func _on_button_pressed() -> void:
	get_tree().quit()
