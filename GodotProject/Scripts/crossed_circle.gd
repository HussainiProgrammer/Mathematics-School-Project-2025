extends Node2D
class_name CrossedCircleSubscene

@onready var circle: Circle2D = $Circle

func updateCircle(newRadius: float, newColor: Color):
	circle.color = newColor
	circle.radius = newRadius
	circle.updateShape()
