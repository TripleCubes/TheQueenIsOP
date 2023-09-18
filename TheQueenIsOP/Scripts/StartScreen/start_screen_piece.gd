extends Node2D

@onready var offset: float = randf_range(0, 1000)
@onready var sine_div: float = randf_range(400, 600)

func _process(_delta):
	self.position.y += sin((Time.get_ticks_msec() + offset) / sine_div) * 0.2
