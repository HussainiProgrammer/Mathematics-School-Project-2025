extends Node2D
class_name DynamicGrid

@export var axis_color: Color = Color("#FFFFFF")
@export var dynamic_color: Color = Color("#50749a")
#@export var sub_dynamic_color: Color = Color("#456789")
@export var static_color: Color = Color("#C0C0C0", 0.1)
#@export var sub_static_color: Color = Color("#808080", 0.1)
@export var main_grid_width: float = 2
#@export var sub_grid_width: float = 1
@export var unit_mark_width: float = 1
@export var spacing: int = 100
@export var axis_length: int = 4000

@onready var dynamicLines: Node2D = $"Dynamic"
@onready var x_axis: Line2D = $"Dynamic/X Axis"
@onready var y_axis: Line2D = $"Dynamic/Y Axis"
@onready var staticLines: Node2D = $"Static"
@onready var marks: Node2D = $Marks
@onready var label: Label = $Marks/Label

var isRotating: bool = false
var desiredAngle: float
var angularVelocity: float

var isScaling: bool = false
var desiredScale: Vector2
var scalingSpeed: Vector2

func _ready() -> void:
	var axis_negative: int = -axis_length/2
	var axis_negative_end: int = axis_negative/spacing

	x_axis.points = [Vector2(0,0), Vector2(axis_negative, 0), Vector2(-axis_negative, 0)]
	y_axis.points = x_axis.points
	
	x_axis.width = main_grid_width
	y_axis.width = main_grid_width
	
	x_axis.default_color = dynamic_color
	y_axis.default_color = dynamic_color
	
	x_axis.get_child(0).width = unit_mark_width
	x_axis.get_child(0).scale.x = unit_mark_width*3
	
	y_axis.get_child(0).width = unit_mark_width
	y_axis.get_child(0).scale.x = unit_mark_width*3

	for i in range(0, axis_length + spacing, spacing):
		if axis_negative + i != 0:
			var line: Line2D = x_axis.duplicate()

			line.position.y = axis_negative + i
			
			var mark_number = line.position.y / spacing
			var mark = label.duplicate()
			mark.text = str(-mark_number)+"i"
			mark.position.x = 10
			mark.position.y = line.position.y + 10
			marks.add_child(mark)
				
			dynamicLines.add_child(line)

	for j in range(0, axis_length + spacing, spacing):
		if axis_negative + j != 0:
			var line: Line2D = y_axis.duplicate()
			line.position.x = axis_negative + j
			
			var mark_number = line.position.x / spacing
			var mark = label.duplicate()
			mark.text = str(mark_number)
			mark.position.y = 10
			mark.position.x = line.position.x + 10
			marks.add_child(mark)
			
			dynamicLines.add_child(line)
			
	label.queue_free()

	x_axis.default_color = static_color
	y_axis.default_color = static_color

	for i in range(0, axis_length + spacing, spacing):
		var line: Line2D = x_axis.duplicate()
		line.get_child(0).queue_free()
		line.position.y = axis_negative + i

		staticLines.add_child(line)

	for j in range(0, axis_length + spacing, spacing):
		var line: Line2D = y_axis.duplicate()
		line.get_child(0).queue_free()
		line.position.x = axis_negative + j

		staticLines.add_child(line)
		
	x_axis.default_color = axis_color
	x_axis.move_to_front()
	y_axis.default_color = axis_color
	y_axis.move_to_front()
	
	#startRotation(330, 5)
	#startScaling(2.5, 5)

func _physics_process(delta: float) -> void:
	#var clockwise = Input.get_axis("test1", "test2")
	#var scalar = Input.get_axis("test4", "test3")
	
	#dynamicLines.rotation += clockwise * PI/2 * delta
	#dynamicLines.scale += scalar * Vector2(4,4) * delta
	
	if isRotating: updateRotation(delta)
	if isScaling: updateScaling(delta)
	
	#if Input.is_action_just_pressed("test1") and !isRotating: startRotation(30, 1)
	#if Input.is_action_just_pressed("test2") and !isRotating: startRotation(-30, 1)
	#if Input.is_action_just_pressed("test3") and !isScaling: startScaling(2, 1)
	#if Input.is_action_just_pressed("test4") and !isScaling: startScaling(0.5, 1)  
	
func _process(delta: float) -> void:
	pass
	#print("Dynamic Grid Log:")
	#print(isScaling)
	#print(isRotating)

func startRotation(delta_theta: float, delta_t: float) -> void:
	isRotating = true
	desiredAngle = dynamicLines.rotation_degrees + (-delta_theta)
	angularVelocity = -delta_theta/delta_t
	
func updateRotation(delta_t: float) -> void:
	if dynamicLines.rotation_degrees == desiredAngle:
		isRotating = false
		return

	dynamicLines.rotation_degrees += angularVelocity*delta_t

	if angularVelocity > 0 and dynamicLines.rotation_degrees > desiredAngle: dynamicLines.rotation_degrees = desiredAngle; isRotating = false
	elif angularVelocity < 0 and dynamicLines.rotation_degrees < desiredAngle: dynamicLines.rotation_degrees = desiredAngle; isRotating = false
	
func startScaling(scalar: float, delta_t: float) -> void:
	isScaling = true
	desiredScale = scalar * dynamicLines.scale
	scalingSpeed = (desiredScale - dynamicLines.scale)/delta_t
	
func updateScaling(delta_t: float) -> void:
	if dynamicLines.scale == desiredScale:
		isScaling = false
		return
		
	dynamicLines.scale += scalingSpeed*delta_t
	if scalingSpeed > Vector2(0, 0) and dynamicLines.scale > desiredScale: dynamicLines.scale = desiredScale
	elif scalingSpeed < Vector2(0, 0) and dynamicLines.scale < desiredScale: dynamicLines.scale = desiredScale
	
func updateGrid() -> void: # change the properties of this Node2D before calling this function (it's literally a copy of _ready)
	var axis_negative: int = -axis_length/2
	var axis_negative_end: int = axis_negative/spacing
	
	x_axis.points = [Vector2(0,0), Vector2(axis_negative, 0), Vector2(-axis_negative, 0)]
	y_axis.points = x_axis.points
	
	x_axis.width = main_grid_width
	y_axis.width = main_grid_width
	
	x_axis.default_color = dynamic_color
	y_axis.default_color = dynamic_color
	
	x_axis.get_child(0).width = unit_mark_width
	x_axis.get_child(0).scale.x = unit_mark_width*3
	
	y_axis.get_child(0).width = unit_mark_width
	y_axis.get_child(0).scale.x = unit_mark_width*3

	for i in range(0, axis_length + spacing, spacing):
		var line: Line2D = x_axis.duplicate()

		line.position.y = axis_negative + i

		dynamicLines.add_child(line)

	for j in range(0, axis_length + spacing, spacing):
		var line: Line2D = y_axis.duplicate()
		line.position.x = axis_negative + j
		
		dynamicLines.add_child(line)

	x_axis.default_color = static_color
	y_axis.default_color = static_color

	for i in range(0, axis_length + spacing, spacing):
		var line: Line2D = x_axis.duplicate()
		line.get_child(0).queue_free()
		line.position.y = axis_negative + i

		staticLines.add_child(line)

	for j in range(0, axis_length + spacing, spacing):
		var line: Line2D = y_axis.duplicate()
		line.get_child(0).queue_free()
		line.position.x = axis_negative + j

		staticLines.add_child(line)
		
	x_axis.default_color = axis_color
	x_axis.move_to_front()
	y_axis.default_color = axis_color
	y_axis.move_to_front()
