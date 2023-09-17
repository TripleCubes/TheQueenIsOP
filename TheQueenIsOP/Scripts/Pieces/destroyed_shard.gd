class_name DestroyedShard
extends Node2D

const VELOCITY_DECREASE: float = 100
const HEIGHT_DECREASE: float = 100

@onready var sprite: Node2D = get_node("Shard")

var h: float:
	set(val):
		h = val
		if (sprite != null):
			sprite.position.y = - h

var dir: = Vector2(1, 0)
var velocity: float = 20

func _ready():
	sprite.position.y = - h

	var show_sprite: = "Shard"
	show_sprite += str(randi_range(0, 2))
	sprite.get_node(show_sprite).show()

	var timer: = get_tree().create_timer(randf_range(3, 4))
	timer.timeout.connect(queue_free)

func _process(_delta):
	if velocity == 0:
		return

	velocity -= VELOCITY_DECREASE * _delta
	if velocity < 0:
		velocity = 0

	h -= HEIGHT_DECREASE * _delta
	if h < 0:
		h = 0

	self.position += dir * velocity * _delta
