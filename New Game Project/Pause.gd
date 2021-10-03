extends Control

func _ready():
	get_tree().paused = true
	$AudioStreamPlayer.play()

func _input(event):
	if event.is_action_pressed("pause"):
		if !get_parent().is_game_over:
			var new_pause_state = !get_tree().paused
			get_tree().paused = new_pause_state
			visible = new_pause_state
			$AudioStreamPlayer.play()
		else:
			get_tree().reload_current_scene()
