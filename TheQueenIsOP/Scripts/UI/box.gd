@tool
class_name UI_Box
extends Node2D

@export var size: Vector2:
	set(val):
		size = val
		queue_redraw()

func _draw():
	draw_rect(Rect2(0, 0, size.x, size.y), Colors.BROWN, true)

	# Top
	draw_rect(Rect2(1,      -1,     size.x - 2, 1         ), Colors.YELLOW, true)
	# Bottom
	draw_rect(Rect2(1,      size.y, size.x - 2, 1         ), Colors.YELLOW, true)
	# Left
	draw_rect(Rect2(-1,     1,      1,          size.y - 2), Colors.YELLOW, true)
	# Right
	draw_rect(Rect2(size.x, 1,      1,          size.y - 2), Colors.YELLOW, true)

	# Top left
	draw_rect(Rect2(0,          0,          1, 1), Colors.YELLOW, true)
	# Top right
	draw_rect(Rect2(size.x - 1, 0,          1, 1), Colors.YELLOW, true)
	# Bottom left
	draw_rect(Rect2(0,          size.y - 1, 1, 1), Colors.YELLOW, true)
	# Bottom right
	draw_rect(Rect2(size.x - 1, size.y - 1, 1, 1), Colors.YELLOW, true)
