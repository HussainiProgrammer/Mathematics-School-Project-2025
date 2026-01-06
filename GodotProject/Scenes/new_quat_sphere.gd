extends Node3D

var isRotating = false
var desired_quaternion: Quaternion
@onready var a: LineEdit = $"../CanvasLayer/ColorRect/a"
@onready var b: LineEdit = $"../CanvasLayer/ColorRect/b"
@onready var c: LineEdit = $"../CanvasLayer/ColorRect/c"
@onready var d: LineEdit = $"../CanvasLayer/ColorRect/d"
@onready var controller: ColorRect = $"../CanvasLayer/ColorRect"

@onready var face: Face = $Face
@export var subdivisions: int = 20

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
			current_face.face_color = Color(color, 1)

			faces.append({"p0": p0, "p1": p1, "p2": p2, "p3": p3, "color": color})
			
			add_child(current_face)

			current_face.drawFace()
			
	face.queue_free()

func sphere_point(u: float, v: float) -> Vector3:
	var theta = u * TAU
	var phi = v * PI
	return Vector3(sin(phi) * cos(theta), cos(phi), sin(phi) * sin(theta))

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().change_scene_to_file("res://Scenes/mainmenu.tscn")
	if isRotating: updateRotation(delta)
	

func startRotation(quat: Quaternion, delta_t: float):
	desired_quaternion = self.quaternion*quat

	if self.quaternion != desired_quaternion: isRotating = true
	
func updateRotation(delta_t: float):
	if abs(desired_quaternion.dot(self.quaternion)) > 0.9999999:
		self.quaternion = desired_quaternion
		isRotating = false
		return
		
	elif abs(desired_quaternion.dot(self.quaternion)) > 0.999: self.quaternion = self.quaternion.slerp(desired_quaternion, 0.5)
	
	else: self.quaternion = self.quaternion.slerp(desired_quaternion, delta_t)

func _on_animate_button_button_down() -> void:
	if not isRotating:
		startRotation(Quaternion(controller.quaternion.x, controller.quaternion.y, controller.quaternion.z, controller.quaternion.w), 3)

func _on_reset_button_button_down() -> void:
	if not isRotating: self.quaternion = Quaternion(0,0,0,1)
