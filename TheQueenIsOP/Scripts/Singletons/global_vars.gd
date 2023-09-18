extends Node

@onready var queen: Piece = get_node("/root/Main/Pieces/Queen")
@onready var pieces: Node2D = get_node("/root/Main/Pieces")
@onready var bkg: Node2D = get_node("/root/Main/Bkg")
@onready var camera: Camera2D = get_node("/root/Main/Camera2D")
@onready var points: RichTextLabel = get_node("/root/Main/UI/Points")

var queens_turn: = true
