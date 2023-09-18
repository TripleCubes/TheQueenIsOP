extends Node2D

const TILE_WH: float = 40

func _draw():
	draw_rect(Rect2(0, 0, Consts.WINDOW_WH, Consts.WINDOW_WH), Colors.BROWN)
	draw_set_transform(Vector2(0, 0), deg_to_rad(-20))

	var num_tile: int = int(ceil(Consts.WINDOW_WH / TILE_WH) + 6)

	var offset: = Vector2(0, 0)
	offset.x = fmod(Time.get_ticks_msec() / float(80), TILE_WH * 2) 
	offset.y = fmod(Time.get_ticks_msec() / float(50), TILE_WH * 2) 

	for x in num_tile:
		var x_even: = x % 2 == 0
		for y in num_tile:
			var y_even: = y % 2 == 0
			if x_even == y_even:
				draw_rect(Rect2(offset.x + x * TILE_WH - TILE_WH * 5, 
								offset.y + y * TILE_WH - TILE_WH * 5, 
								TILE_WH, TILE_WH), Colors.YELLOW)

func _process(_delta):
	queue_redraw()
