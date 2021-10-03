extends Position2D

onready var label = get_node("Label")
onready var tween = get_node("Tween")
var amount = 0

func _ready():
	if amount >= 0:
		label.set_text("+" + str(amount))
		label.add_color_override("font_color", Color(0,1,0,1))
	else:
		label.set_text(str(amount))
		label.add_color_override("font_color", Color(1,0,0,1))
	tween.interpolate_property(self, 'scale', scale, Vector2(0.5,0.5), 0.2, tween.TRANS_LINEAR, tween.EASE_OUT)
	tween.interpolate_property(self, 'scale', Vector2(0.5,0.5), Vector2(0.1,0.1), 0.2, tween.TRANS_LINEAR, tween.EASE_OUT, 0.3)
	tween.start()


func _on_Tween_tween_all_completed() -> void:
	self.queue_free()
