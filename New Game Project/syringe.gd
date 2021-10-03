extends Area2D

var speed = 160.0
var velocity = Vector2.ZERO

func _ready():
	speed *= rand_range(1, 2)
	if speed<0:
		$AnimatedSprite.flip_h = true
	var screentime = rand_range(0.4, 1)
	yield(get_tree().create_timer(screentime), "timeout")
	if !$AnimatedSprite.playing:
		queue_free()

func _physics_process(delta):
	velocity.x = speed * delta
	translate(velocity)


func _on_syringe_area_entered(area):
	speed *= 0.5
	$AnimatedSprite.play("explode")
	match area.name:
		"green":
			if (get_parent().return_color()) == 0:
				get_parent().gain_points()
				$AudioStreamPlayer.pitch_scale = 0.9
			else:
				get_parent().lose_points()
				$AudioStreamPlayer.pitch_scale = 0.4
			$AudioStreamPlayer.play()
		"purple":
			if (get_parent().return_color()) == 1:
				get_parent().gain_points()
				$AudioStreamPlayer.pitch_scale = 0.9
			else:
				get_parent().lose_points()
				$AudioStreamPlayer.pitch_scale = 0.4
			$AudioStreamPlayer.play()
		"yellow":
			if (get_parent().return_color()) == 2:
				get_parent().gain_points()
				$AudioStreamPlayer.pitch_scale = 0.9
			else:
				get_parent().lose_points()
				$AudioStreamPlayer.pitch_scale = 0.4
			$AudioStreamPlayer.play()


func _on_AnimatedSprite_animation_finished():
	queue_free()
