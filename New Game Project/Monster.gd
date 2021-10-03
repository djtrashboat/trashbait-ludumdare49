extends KinematicBody2D

onready var SPRITE = $AnimatedSprite
var rng = RandomNumberGenerator.new()

enum {
	IDLE,
	NEW_DIRECTION,
	MOVE
}

var speed = 70
var downtimemin = 3
var downtimemax = 12
var state = IDLE
var direction = Vector2.ZERO


const hp = 2
var _hp:int


func _process(delta):
	match state:
		IDLE:
			pass
		NEW_DIRECTION:
			pass
		MOVE:
			pass

func _physics_process(delta):
	move_and_slide(direction * speed)

func _ready():
	_hp = hp
	rng.randomize()
	$unstable.wait_time = rng.randf_range(5, 10)
	$unstable.start()


func change_MOVE():
	SPRITE.play("unst")
	$sounds/awake.play()
	yield(get_tree().create_timer(0.2), "timeout")
	SPRITE.play("run")
	state = MOVE
	_hp = hp
	print("change move")	

func change_IDLE():
	SPRITE.play("default")
	state = IDLE
	$unstable.wait_time = rng.randf_range(2, 12)
	$unstable.start()
	print("change idle")

func take_dmg():
	if state == MOVE:
		$sounds/hit.play()
		print("dmg")
		_hp -= 1
		if _hp <= 0:
			die()
		SPRITE.modulate = Color.red
		direction = Vector2.ZERO
		yield(get_tree().create_timer(0.06), "timeout")
		SPRITE.modulate = Color.white

func die():
	change_IDLE()

func _on_hurtbox_area_entered(area):
	if area.name == "syringe":
		take_dmg()

func _on_change_dir_timeout():
	match state:
		IDLE:
			direction = Vector2.ZERO
		MOVE:
			var angle = get_angle_to(get_parent().get_player_position())
			direction = Vector2(cos(angle), sin(angle))


func _on_unstable_timeout():
	change_MOVE()

func _on_difficulty_timeout():
	if speed <= 180:
		print("rise difficulty")
		speed += 10
	else:
		$difficulty.stop()
	if downtimemax > 10:
		downtimemax-=1
	elif downtimemax == 10:
		downtimemax-=1
		downtimemin-=1
	elif downtimemax > 5:
		downtimemax-=1

