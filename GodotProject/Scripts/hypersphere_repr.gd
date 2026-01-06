extends Node3D
class_name HypersphereRepr

@onready var face: Face = $Face

@export var subdivisions: int = 20
@export var radius: float = 1
var color: Color = Color.BLUE

@onready var crossed_circle: CrossedCircleSubscene = $"../CanvasLayer/ColorRect/SubViewportContainer/SubViewport/CrossedCircle"
@onready var crossed_sphere: CrossedSphere = $"../CanvasLayer/ColorRect2/SubViewportContainer/SubViewport/CrossedSphere"

func _ready():
	for i in range(subdivisions):
		for j in range(subdivisions):
			var u0 = float(i) / subdivisions
			var u1 = float(i + 1) / subdivisions
			var v0 = float(j) / subdivisions
			var v1 = float(j + 1) / subdivisions

			var p0 = sphere_point(u0, v0)
			var p1 = sphere_point(u1, v0)
			var p2 = sphere_point(u1, v1)
			var p3 = sphere_point(u0, v1)

			var current_face = face.duplicate()

			current_face.p0 = p0
			current_face.p1 = p1
			current_face.p2 = p2
			current_face.p3 = p3
			current_face.face_color = Color((1 - v0)**0.9, (1 - v0)**0.9, 1)
			
			add_child(current_face)
			current_face.drawFace()
			
	face.queue_free()
	
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("test3"): position.y += 0.8 * delta
	if Input.is_action_pressed("test4"): position.y -= 0.8 * delta
	if Input.is_action_just_pressed("quit"):
		get_tree().change_scene_to_file("res://Scenes/mainmenu.tscn")
	
	if abs(position.y) <= radius:
		crossed_circle.updateCircle(100*(radius - abs(position.y)), getColor())
		crossed_sphere.updateSphere((radius - abs(position.y))/radius, getColor())

func sphere_point(u: float, v: float) -> Vector3:
	var theta = u * TAU
	var phi = v * PI
	return Vector3(radius*sin(phi)*cos(theta), radius*cos(phi), radius*sin(phi)*sin(theta))
	
func getColor(): return Color((1 - abs(radius + position.y)/(2*radius))**0.9, (1 - abs(radius + position.y)/(2*radius))**0.9, 1)
