extends Node

var Paused: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_text_clear_carets_and_selection"):
		if (!Global.Paused):
			Global.Paused = true
		else: Global.Paused = false
