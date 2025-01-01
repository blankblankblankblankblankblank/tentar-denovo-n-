extends VideoOptionsMenu

func _on_v_sync_setting_changed(value: Variant) -> void:
	DisplayServer.window_set_vsync_mode(int(value)*2)
