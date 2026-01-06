extends Polygon2D
class_name Circle2D

@export var segments: float = 32
@export var radius: float = 4

func _ready() -> void:
	var points = []
	
	for i in range(segments):
		var angle = i * TAU / segments
		points.append(Vector2(cos(angle) * radius, sin(angle) * radius))

	polygon = points

func updateShape() -> void: # NOTE: Change [radius] and [segments] indepentedly before calling this function
	var points = []
	
	for i in range(segments):
		var angle = i * TAU / segments
		points.append(Vector2(cos(angle) * radius, sin(angle) * radius))

	polygon = points
