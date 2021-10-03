extends KinematicBody2D

var speed = 130.0
var direction = Vector2()
var is_attacking = false
var is_imune = false
var can_attack = true
const hp = 3
var _hp = 3

onready var SPRITE = $AnimatedSprite
const SYRINGE = preload("res://syringe.tscn")

signal die

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	get_move_direction()
	move_and_slide(direction * speed)

func _process(delta):
	get_attack_input()
	play_animation()

func get_move_direction():
	direction = Vector2((Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")), (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")))

func get_attack_input():
	if Input.is_action_just_pressed("attack") and can_attack:
		attack()

func attack():
	$sounds/vush.play()
	is_attacking = true
	can_attack = false
	var _syringe = SYRINGE.instance()
	_syringe.position = Vector2(position.x, position.y-7)
	if SPRITE.flip_h == true:
		_syringe.speed*=-1
	get_parent().add_child(_syringe)
	speed = speed / 3
	yield(get_tree().create_timer(0.1), "timeout")
	speed *=3

func play_animation():
	if is_attacking:
		SPRITE.play("attack")
	elif (direction != Vector2.ZERO):
		SPRITE.play("run")
		if direction.x<0:
			SPRITE.flip_h = true
		if direction.x>0:
			SPRITE.flip_h = false
	else:
		SPRITE.play("default")

func take_dmg():
	_hp-=1
	is_imune = true
	get_parent().update_helth_UI()
	$sounds/hurt.play()
	if _hp<=0:
		die()
	else:
		$AnimatedSprite.modulate = Color.red
		yield(get_tree().create_timer(.1), "timeout")
		$AnimatedSprite.modulate = Color.white
		yield(get_tree().create_timer(.9), "timeout")
		is_imune = false

func die():
	set_physics_process(false)
	emit_signal("die")

func _on_AnimatedSprite_animation_finished():
	if SPRITE.animation == "attack":
		is_attacking = false
		yield(get_tree().create_timer(rand_range(0.07, 0.15)), "timeout")
		can_attack = true


func _on_hurtbox_body_entered(body):
	if !is_imune:
		take_dmg()
		body.die()
