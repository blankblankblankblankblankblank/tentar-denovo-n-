class_name MasterOptionsMenu
extends Control

func _init() -> void:
	visible = false
	Config.load_config_file()

func _unhandled_input(event):
	if event.is_action_pressed('ui_text_clear_carets_and_selection'):
		#visible is a bool, and it alternates between 0 and 2
		visible = !visible
		Input.mouse_mode = int(!visible)*2
	if event.is_action_pressed("ui_page_down"):
		$TabContainer.current_tab = ($TabContainer.current_tab+1) % $TabContainer.get_tab_count()
	elif event.is_action_pressed("ui_page_up"):
		if $TabContainer.current_tab == 0:
			$TabContainer.current_tab = $TabContainer.get_tab_count()-1
		else:
			$TabContainer.current_tab = $TabContainer.current_tab-1
