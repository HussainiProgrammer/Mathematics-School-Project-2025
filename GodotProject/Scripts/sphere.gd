extends Node3D
class_name FlatlanderSphere

@onready var face: Face = $Face
@export var subdivisions: int = 20
@onready var decrease_button_1: Button = $"../CanvasLayer/ColorRect/decreaseButton1"
@onready var increase_button_1: Button = $"../CanvasLayer/ColorRect/increaseButton1"
@onready var decrease_button_2: Button = $"../CanvasLayer/ColorRect/decreaseButton2"
@onready var increase_button_2: Button = $"../CanvasLayer/ColorRect/increaseButton2"
@onready var decrease_button_3: Button = $"../CanvasLayer/ColorRect/decreaseButton3"
@onready var increase_button_3: Button = $"../CanvasLayer/ColorRect/increaseButton3"

var faces: Array = []

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
			var color = Color.from_hsv(u0, 1 - v0*v0*v0*v0, 1)
			#var color = Color.from_hsv(v0, 1, 1)
			#var color = Color.from_hsv((v0*u0)**0.8, 1, 1)

			var current_face = face.duplicate()

			current_face.p0 = p0
			current_face.p1 = p1
			current_face.p2 = p2
			current_face.p3 = p3
			current_face.face_color = Color(color, 0.64)

			faces.append({"p0": p0, "p1": p1, "p2": p2, "p3": p3, "color": color})
			
			add_child(current_face)

			current_face.drawFace()
			
	face.queue_free()
	
func _physics_process(delta: float) -> void:
	pass # Debugging:
	if increase_button_1.button_pressed: rotation_degrees.x += 90 * delta
	if decrease_button_1.button_pressed: rotation_degrees.x -= 90 * delta
	if increase_button_3.button_pressed: rotation_degrees.y += 90 * delta
	if decrease_button_3.button_pressed: rotation_degrees.y -= 90 * delta
	if increase_button_2.button_pressed: rotation_degrees.z += 90 * delta
	if decrease_button_2.button_pressed: rotation_degrees.z -= 90 * delta

func sphere_point(u: float, v: float) -> Vector3:
	var theta = u * TAU
	var phi = v * PI
	return Vector3(sin(phi) * cos(theta), cos(phi), sin(phi) * sin(theta))

func _on_gobackbtn_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/mainmenu.tscn")
