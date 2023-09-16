class_name DestroyedPiece
extends Node2D

func _ready():
	var timer: = get_tree().create_timer(randf_range(3, 4))
	timer.timeout.connect(queue_free)
