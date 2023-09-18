extends Node2D

func _on_start_button_pressed():
	var tween: = get_tree().create_tween()
	tween.tween_property(GlobalVars.camera, "position", Vector2(-250, 0), 0.4)

	var timer: = get_tree().create_timer(1.4)
	timer.timeout.connect(func():
		var tween_0: = get_tree().create_tween()
		tween_0.tween_property(GlobalVars.camera, "position", Vector2(0, 0), 0.4)
	)
