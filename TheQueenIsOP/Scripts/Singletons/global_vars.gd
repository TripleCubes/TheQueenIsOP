extends Node

@onready var queen: Piece = get_node("/root/Main/Pieces/Queen")
@onready var pieces: Node2D = get_node("/root/Main/Pieces")
@onready var bkg: Node2D = get_node("/root/Main/Bkg")
@onready var camera: Camera2D = get_node("/root/Main/Camera2D")
@onready var points: RichTextLabel = get_node("/root/Main/UI/Points")
@onready var op_mode_bar: UI_ProgressBarHorizontal = get_node("/root/Main/UI/OPModeBar")
@onready var ui: Node2D = get_node("/root/Main/UI")

var queens_turn: = true
var num_moved: int = 20
