extends Node2D

@export var radius: float = 50.0
@export var fill_color: Color = Color.BLUE
@export var outline_color: Color = Color.WHITE
@export var outline_width: float = 3.0

func _draw():
	draw_circle(Vector2.ZERO, radius, fill_color)
	draw_arc(Vector2.ZERO, radius, 0, TAU, 64, outline_color, outline_width)
