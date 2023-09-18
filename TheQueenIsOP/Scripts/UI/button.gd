@tool
class_name UI_Button
extends Button

@export var border_color: Color

func _ready():
	focus_mode = Control.FOCUS_NONE
	theme = preload("res://Styles/style.tres")

func _draw():
	# Top
	draw_rect(Rect2(1,      -1,     size.x - 2, 1         ), border_color, true)
	# Bottom
	draw_rect(Rect2(1,      size.y, size.x - 2, 1         ), border_color, true)
	# Left
	draw_rect(Rect2(-1,     1,      1,          size.y - 2), border_color, true)
	# Right
	draw_rect(Rect2(size.x, 1,      1,          size.y - 2), border_color, true)

	# Top left
	draw_rect(Rect2(0,          0,          1, 1), border_color, true)
	# Top right
	draw_rect(Rect2(size.x - 1, 0,          1, 1), border_color, true)
	# Bottom left
	draw_rect(Rect2(0,          size.y - 1, 1, 1), border_color, true)
	# Bottom right
	draw_rect(Rect2(size.x - 1, size.y - 1, 1, 1), border_color, true)

func _process(_delta):
	queue_redraw()
