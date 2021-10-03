extends Node2D

var floating_text = preload("res://FloatingText.tscn")

var points:int = 0

var rng = RandomNumberGenerator.new()
var is_game_over = false

onready var song = get_node("song")

enum {
	GREEN,
	PURPLE,
	YELLOW
}

var erlenmeyer = GREEN

func _ready():
	rng.randomize()
	random_color()
	update_outline()
	update_helth_UI()

func _process(delta):
	if !song.playing:
		song.play()

func get_player_position()->Vector2:
	return $Player.position

func gain_points():
#	var text = floating_text.instance()
#	text.amount = 10
#	match erlenmeyer:
#		GREEN:
#			text.position = ($green.position) + Vector2(0,-20)
#		PURPLE:
#			text.position = ($purple.position) + Vector2(0,-20)
#		YELLOW:
#			text.position = ($yellow.position) + Vector2(0,-20)
#	add_child(text)
	points+=10
	instance_floating_text(10)
	random_color()
	update_outline()
	$Control/points.bbcode_text = ("points:") + String(points)

func lose_points():
#	var text = floating_text.instance()
#	text.amount = -5
#	match erlenmeyer:
#		GREEN:
#			text.position = ($green.position) + Vector2(0,-20)
#		PURPLE:
#			text.position = ($purple.position) + Vector2(0,-20)
#		YELLOW:
#			text.position = ($yellow.position) + Vector2(0,-20)
#	add_child(text)
	instance_floating_text(-5)
	points-=5
	$Control/points.bbcode_text = ("points:") + String(points)

func return_color():
	return erlenmeyer

func update_outline():
	$green/outline.visible = false
	$purple/outline.visible = false
	$yellow/outline.visible = false
	match erlenmeyer:
		GREEN:
			$green/outline.visible = true
		PURPLE:
			$purple/outline.visible = true
		YELLOW:
			$yellow/outline.visible = true

func update_helth_UI():
	$Control/hpUI.frame = $Player._hp

func random_color():
	match rng.randi()%4:
		1:
			erlenmeyer = GREEN
		2:
			erlenmeyer = PURPLE
		3:
			erlenmeyer = YELLOW


func _on_Player_die():
	game_over()

func game_over():
	is_game_over = true
	get_tree().paused = true
	$GameOver/gameoveraudio.play()
	$GameOver/Points.text = ("score:") + String(points)
	$GameOver.visible = true

func instance_floating_text(x:int):
	var text = floating_text.instance()
	text.amount = x
	match erlenmeyer:
		GREEN:
			text.position = ($green.position) + Vector2(0,-20)
		PURPLE:
			text.position = ($purple.position) + Vector2(0,-20)
		YELLOW:
			text.position = ($yellow.position) + Vector2(0,-20)
	add_child(text)
