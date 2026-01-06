extends Node3D
class_name FlatlanderSurfaceProjection

@onready var sphere: FlatlanderSphere = $"../Sphere"
@onready var face: Face = $Face

@export var stop_distance: float = 0.001
@export var enabled: bool = false

var initial_drawing = false

var previousSphereRotation: Vector3
@onready var check_1: CheckButton = $"../CanvasLayer/ColorRect/check1"

var enbl = false

func _ready() -> void:
	for i in range(sphere.subdivisions**2):
		var newFace = face.duplicate()
		add_child(newFace)

	face.queue_free()		
	if enabled: drawProjection()
	else: hide()
	
	previousSphereRotation = sphere.rotation

func _process(delta: float) -> void:	 
	if enbl: drawProjection()
	
func drawProjection():
	if sphere.rotation != previousSphereRotation or !initial_drawing:
		initial_drawing = true
		for i in range(len(sphere.faces)):
			var data = sphere.faces[i]
			
			var p0 = get_real_position(data["p0"], sphere.rotation)
			var p1 = get_real_position(data["p1"], sphere.rotation)
			var p2 = get_real_position(data["p2"], sphere.rotation)
			var p3 = get_real_position(data["p3"], sphere.rotation)

			var face: Face = get_child(i)
			if is_valid_projection(p0, p1, p2, p3):
				face.p0 = Vector3(p0.x/(p0.y + 1), 0, p0.z/(p0.y + 1))
				face.p1 = Vector3(p1.x/(p1.y + 1), 0, p1.z/(p1.y + 1))
				face.p2 = Vector3(p2.x/(p2.y + 1), 0, p2.z/(p2.y + 1))
				face.p3 = Vector3(p3.x/(p3.y + 1), 0, p3.z/(p3.y + 1))
				face.face_color = data["color"]
				face.updateFace()
				face.show()

			else: face.hide()
			
		previousSphereRotation = sphere.rotation

func get_real_position(pos: Vector3, radians: Vector3) -> Vector3:
	#var sine: float
	#var cosine: float
	#var new_pos = pos
#
	#sine = sin(radians.x)
	#cosine = cos(radians.x)
	#var y = new_pos.y * cosine - new_pos.z * sine
	#var z = new_pos.y * sine + new_pos.z * cosine
	#new_pos.y = y
	#new_pos.z = z
#
	#sine = sin(radians.y)
	#cosine = cos(radians.y)
	#var x = new_pos.x * cosine + new_pos.z * sine
	#z = new_pos.z * cosine - new_pos.x * sine
	#new_pos.x = x
	#new_pos.z = z
#
	#sine = sin(radians.z)
	#cosine = cos(radians.z)
	#x = new_pos.x * cosine - new_pos.y * sine
	#y = new_pos.x * sine + new_pos.y * cosine
	#new_pos.x = x
	#new_pos.y = y
	#
	#return new_pos
	var rotation_basis = Basis.from_euler(radians);
	return rotation_basis * pos;

func get_quadrant(p: Vector3):
	if p.x > 0 and p.z > 0: return 1
	elif p.x < 0 and p.z > 0: return 2
	elif p.x < 0 and p.z < 0: return 3
	elif p.x > 0 and p.z < 0: return 4
	
func is_valid_projection(p0: Vector3, p1: Vector3, p2: Vector3, p3: Vector3) -> bool:
	if abs(p0.y + 1) > stop_distance and abs(p1.y + 1) > stop_distance and abs(p2.y + 1) > stop_distance and abs(p3.y + 1) > stop_distance:
		var quadrants = {}
		quadrants[get_quadrant(p0)] = true
		quadrants[get_quadrant(p1)] = true
		quadrants[get_quadrant(p2)] = true
		quadrants[get_quadrant(p3)] = true
		
		return len(quadrants) <= 2
		
	return false
	
func enableProjection():
	enbl = true
	show()
	
func disableProjection():
	enbl = false
	hide()

func _on_check_1_toggled(toggled_on: bool) -> void:
	if enbl: disableProjection()
	else: enableProjection()
