class_name MasterOptionsMenu
extends Control

func _init() -> void:
	visible = false

func _unhandled_input(event):
	if event.is_action_pressed('ui_text_clear_carets_and_selection'):
		if visible == true:
			visible = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			set_focus_mode(Control.FOCUS_NONE)
			return
		else:
			visible = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			set_focus_mode(Control.FOCUS_ALL)
	if event.is_action_pressed("ui_page_down"):
		$TabContainer.current_tab = ($TabContainer.current_tab+1) % $TabContainer.get_tab_count()
	elif event.is_action_pressed("ui_page_up"):
		if $TabContainer.current_tab == 0:
			$TabContainer.current_tab = $TabContainer.get_tab_count()-1
		else:
			$TabContainer.current_tab = $TabContainer.current_tab-1
