extends Node2D
class_name LinelanderCircle

var radius := 200
var circle_center := Vector2(0, 0)
var resolution := 120
var point_data := []
@onready var lines: Node2D = $"../Lines"
@onready var camera: Camera2D = $"../Camera2D"
var show_projection = true
var show_pro_marks = true
var show_circle_marks = false
var show_rays = false
var viewport_size
@onready var posi_mark: Node2D = $"../PointsMarks/iMark"
@onready var pos1_mark: Node2D = $"../PointsMarks/1Mark"
@onready var negi_mark: Node2D = $"../PointsMarks/-iMark"
@onready var neg1_mark: Node2D = $"../PointsMarks/-1Mark"
@onready var posiray: Line2D = $"../Rays/posiray"
@onready var negiray: Line2D = $"../Rays/negiray"
@onready var pos_1_ray: Line2D = $"../Rays/pos1ray"
@onready var neg_1_ray: Line2D = $"../Rays/neg1ray"
@onready var child_marks: Node2D = $ChildMarks
@onready var rays: Node2D = $"../Rays"
@onready var points_marks: Node2D = $"../PointsMarks"
@onready var angle_input: LineEdit = $"../CanvasLayer/ColorRect/angleInput"
@onready var decrease_button: Button = $"../CanvasLayer/ColorRect/decreaseButton"
@onready var increase_button: Button = $"../CanvasLayer/ColorRect/increaseButton"
@onready var decrease_button_2: Button = $"../CanvasLayer/ColorRect/decreaseButton2"
@onready var increase_button_2: Button = $"../CanvasLayer/ColorRect/increaseButton2"

func _ready() -> void:
	var line = lines.get_child(0)
	for i in range(resolution-1): lines.add_child(line.duplicate())
	
	pos1_mark.hide()
	posi_mark.hide()
	neg1_mark.hide()
	negi_mark.hide()
	
	child_marks.hide()
	rays.hide()

	drawProjection()

func _process(delta: float) -> void:
	if increase_button.button_pressed or Input.is_action_pressed("test2"):
		rotation_degrees += 120 * delta
		angle_input.text = str(rotation_degrees)
	elif decrease_button.button_pressed or Input.is_action_pressed("test1"):
		rotation_degrees -= 120 * delta
		angle_input.text = str(rotation_degrees)
		
	if increase_button_2.button_pressed or Input.is_action_pressed("test3"): camera.zoom *= 1.01
	elif decrease_button_2.button_pressed or Input.is_action_pressed("test4"): camera.zoom = Vector2(max(camera.zoom.x*0.99, 0.48), max(camera.zoom.x*0.99, 0.48))

	if Input.is_action_just_pressed("quit"): get_tree().change_scene_to_file("res://Scenes/mainmenu.tscn")
		
	drawProjection()
	
func _draw():
	point_data.clear()
	var ratio = 360/resolution
	for i in range(resolution):
		var angle1 = deg_to_rad(ratio*i)
		var angle2 = deg_to_rad(ratio*i + ratio)
		
		var p1 = circle_center + Vector2(cos(angle1), sin(angle1)) * radius
		var p2 = circle_center + Vector2(cos(angle2), sin(angle2)) * radius
		
		var color = Color.from_hsv(float(i) / resolution, 1, 1)
		draw_line(p1, p2, color, 6)

		point_data.append({"p1": p1, "p2": p2, "color": color})

func drawProjection():
	var cosine = cos(rotation)
	var sine = sin(rotation)

	for i in range(len(point_data)):
		var data = point_data[i]
		
		var local_p1 = data["p1"]
		var local_p2 = data["p2"]
		
		var p1 = Vector2(local_p1.x*cosine - local_p1.y*sine, local_p1.x*sine + local_p1.y*cosine)
		var p2 = Vector2(local_p2.x*cosine - local_p2.y*sine, local_p2.x*sine + local_p2.y*cosine)

		if abs(p1.y - 200) > 0.1 and abs(p2.y - 200) > 0.1:
			var line: Line2D = lines.get_child(i)
			
			var m1 = (p1.y - 200)/(p1.x)
			var m2 = (p2.y - 200)/(p2.x)
		
			var proj1 = Vector2((m1*p1.x - p1.y)/m1, 0)
			var proj2 = Vector2((m2*p2.x - p2.y)/m2, 0)
			
			line.points = [proj1, proj2]
			line.default_color = data["color"]
			
	var pos1vector = Vector2(200*cosine, 200*sine)
	var posivector = Vector2(200*sine, -200*cosine)
	var neg1vector = -pos1vector
	var negivector = -posivector

	if abs(pos1vector.y - 200) > 0.1:
		pos1_mark.show()
		pos_1_ray.show()
		var m = (pos1vector.y - 200)/(pos1vector.x)	
		var proj = Vector2((m*pos1vector.x - pos1vector.y)/m, 0)
		pos1_mark.position = proj
		pos_1_ray.points = [Vector2(0, 200), Vector2(0, 200) + (proj - Vector2(0, 200))*10]
	else:
		pos1_mark.hide()
		pos_1_ray.hide()
	
	if abs(neg1vector.y - 200) > 0.1:
		neg1_mark.show()
		neg_1_ray.show()
		var m = (neg1vector.y - 200)/(neg1vector.x)	
		var proj = Vector2((m*neg1vector.x - neg1vector.y)/m, 0)
		neg1_mark.position = proj
		neg_1_ray.points = [Vector2(0, 200), Vector2(0, 200) + (proj - Vector2(0, 200))*10]
	else:
		neg1_mark.hide()
		neg_1_ray.hide()
		
	if abs(posivector.y - 200) > 0.1:
		var proj: Vector2
		posi_mark.show()
		posiray.show()
		if posivector == Vector2(0, -200):
			proj = Vector2.ZERO
		else:
			var m = (posivector.y - 200)/(posivector.x)	
			proj = Vector2((m*posivector.x - posivector.y)/m, 0)

		posi_mark.position = proj
		posiray.points = [Vector2(0, 200), Vector2(0, 200) + (proj - Vector2(0, 200))*10]
				
	else:
		posi_mark.hide()
		posiray.hide()
	
	if abs(negivector.y - 200) > 0.1:
		negi_mark.show()
		negiray.show()

		var m = (negivector.y - 200)/(negivector.x)	
		var proj = Vector2((m*negivector.x - negivector.y)/m, 0)
		negi_mark.position = proj
		
		negiray.points = [Vector2(0, 200), Vector2(0, 200) + (proj - Vector2(0, 200))*5]
	else:
		negi_mark.hide()
		negiray.hide()

func _on_check_1_toggled(toggled_on: bool) -> void:
	show_projection = toggled_on
	if show_projection: lines.show()
	else: lines.hide()

func _on_check_2_toggled(toggled_on: bool) -> void:
	show_rays = toggled_on
	if show_rays: rays.show()
	else: rays.hide()

func _on_check_3_toggled(toggled_on: bool) -> void:
	show_circle_marks = toggled_on
	if show_circle_marks: child_marks.show()
	else: child_marks.hide()
	
func _on_check_4_toggled(toggled_on: bool) -> void:
	show_pro_marks = toggled_on
	if show_pro_marks: points_marks.show()
	else: points_marks.hide()

func _on_angle_input_text_submitted(text: String) -> void: if text.is_valid_float(): rotation_degrees = float(text)

func _on_gobackbtn_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/mainmenu.tscn")
