extends Node2D
class_name ComplexNumber

@onready var line: Line2D = $Line
@onready var circle: Polygon2D = $Circle
@onready var x_line: Line2D = $xLine
@onready var x_circle: Polygon2D = $xCircle
@onready var y_line: Line2D = $yLine
@onready var y_circle: Polygon2D = $yCircle
@onready var label: Label = $Circle/Label

var vector: Vector2
var length: float
var radians: float
var degrees: float

var unit: float = 100

var animated = false

var is_initial_animating: bool = false
var is_animating_x: bool = false
var xSpeed: float
var xCircleSpeed: float
var is_animating_y: bool = false
var ySpeed: float
var yCircleSpeed: float
var is_animating_line: bool = false
var speed: float
var circleSpeed: float

var isRotating: bool = false
var desiredAngle: float
var angularVelocity: float

var isScaling: bool = false
var desiredScale: float
var scalingSpeed: float

@export var line_color: Color = Color("#ff0000")

func _ready() -> void:
	line.default_color = line_color
	circle.color = line_color
	label.hide()

func _physics_process(delta: float) -> void:
	if is_initial_animating: updateInitialAnimation(delta)
	
	if isRotating: updateRotation(delta)
	#elif Input.is_action_just_pressed("test1"): startRotation(30, 1)
	#elif Input.is_action_just_pressed("test2"): startRotation(-30, 1)
	#
	if isScaling: updateScaling(delta)
	#elif Input.is_action_just_pressed("test3"): startScaling(2, 1)
	#elif Input.is_action_just_pressed("test4"): startScaling(0.5, 1)

func _process(delta: float) -> void:
	pass
	#print("Complex Number Log:")
	#print(is_initial_animating)
	#print(isRotating)
	#print(isScaling)

func initialize(a: float, b: float):
	vector = Vector2(a, -b)
	length = vector.length()
	radians = vector.angle()
	degrees = rad_to_deg(radians)
	
	label.text = format_complex(a, b)

func startInitialAnimation(delta_t):
	is_initial_animating = true
	var t = delta_t/3
	
	if vector.x != 0: is_animating_x = true
	elif vector.y != 0: is_animating_y = true
	else: is_animating_line = true
		
	line.rotation_degrees = rad_to_deg(vector.angle())
	
	speed = length/t
	xSpeed = vector.x/t
	ySpeed = vector.y/t
	circleSpeed = 1/t
	xCircleSpeed = 1/t
	yCircleSpeed = 1/t

	
func updateInitialAnimation(delta_t):
	if is_animating_x:
		if x_line.scale.x == vector.x and x_circle.scale == Vector2(1, 1):
			is_animating_x = false
			y_line.position.x = vector.x * unit
			y_circle.position.x  = vector.x * unit
			is_animating_y = true
			return
			
		x_circle.scale += Vector2(1, 1)*xCircleSpeed*delta_t
		x_line.scale.x += xSpeed*delta_t
		
		if xSpeed > 0 and x_line.scale.x > vector.x: x_line.scale.x = vector.x
		if xSpeed < 0 and x_line.scale.x < vector.x: x_line.scale.x = vector.x
		
		x_circle.position.x = x_line.scale.x * unit

		if x_circle.scale > Vector2(1, 1): x_circle.scale = Vector2(1, 1)

	elif is_animating_y:
		if vector.y == 0 or (y_line.scale.x == -vector.y and y_circle.scale == Vector2(1, 1)):
			is_animating_y = false
			is_animating_line = true
			return
	
		y_circle.scale += Vector2(1, 1)*yCircleSpeed*delta_t
		y_line.scale.x += -ySpeed*delta_t
		
		if ySpeed < 0 and y_line.scale.x > -vector.y: y_line.scale.x = -vector.y
		if ySpeed > 0 and y_line.scale.x < -vector.y: y_line.scale.x = -vector.y
		
		y_circle.position.y = -y_line.scale.x * unit

		if y_circle.scale > Vector2(1, 1): y_circle.scale = Vector2(1, 1)
		
	elif is_animating_line:
		if line.scale.x == length and circle.scale == Vector2(1, 1):
			x_line.hide()
			x_circle.hide()
			y_line.hide()
			y_circle.hide()
			
			is_animating_line = false
			is_initial_animating = false
			animated = true
			
			label.show()

			return
	
		circle.scale += Vector2(1, 1)*circleSpeed*delta_t
		line.scale.x += speed*delta_t

		if speed > 0 and line.scale.x > length: line.scale.x = length
		if speed < 0 and line.scale.x < length: line.scale.x = length
		
		circle.position = unit * line.scale.x * vector.normalized()

		if circle.scale > Vector2(1, 1): circle.scale = Vector2(1, 1)

func startRotation(delta_theta, delta_t):
	isRotating = true
	desiredAngle = line.rotation_degrees + -delta_theta
	angularVelocity = -delta_theta/delta_t
	
func updateRotation(delta_t):
	if line.rotation_degrees == desiredAngle:
		isRotating = false
		return
		
	line.rotation_degrees += angularVelocity*delta_t

	if angularVelocity > 0 and line.rotation_degrees > desiredAngle: line.rotation_degrees = desiredAngle; isRotating = false
	if angularVelocity < 0 and line.rotation_degrees < desiredAngle: line.rotation_degrees = desiredAngle; isRotating = false
	
	circle.position.x = unit * line.scale.x * cos(line.rotation)
	circle.position.y = unit * line.scale.x * sin(line.rotation)
	
func startScaling(scalar, delta_t):
	isScaling = true
	desiredScale = line.scale.x*scalar
	scalingSpeed = (desiredScale - line.scale.x)/delta_t

func updateScaling(delta_t):
	if line.scale.x == desiredScale:
		isScaling = false
		return
		
	line.scale.x += scalingSpeed*delta_t
	
	if scalingSpeed > 0 and line.scale.x > desiredScale: line.scale.x = desiredScale; isScaling = false
	if scalingSpeed < 0 and line.scale.x < desiredScale: line.scale.x = desiredScale; isScaling = false
	
	circle.position.x = unit * line.scale.x * cos(line.rotation)
	circle.position.y = unit * line.scale.x * sin(line.rotation)

func reset():
	animated = false
	x_line.scale.x = 0
	x_circle.position.x = 0
	x_circle.scale.x = 0
	x_circle.scale.y = 0
	x_line.show()
	x_circle.show()
	
	y_line.position.x = 0
	y_line.scale.x =  0
	y_circle.position.x = 0
	y_circle.position.y = 0
	y_circle.scale.x = 0
	y_circle.scale.y = 0
	y_line.show()
	y_circle.show()
	
	line.scale.x = 0
	circle.position.x = 0
	circle.position.y = 0
	circle.scale.x = 0
	circle.scale.y = 0
	
	label.text = ""
	label.hide()
	
func format_complex(a: float, b: float) -> String:
	if   a == 0 and b == 0: return "0"
	elif a      ==       0: return str(b) + "i"
	elif b      ==       0: return str(a)
	elif b      >=       0: return str(a) + " + " + str(b) + "i"
	else                  : return str(a) + " - " + str(-b) + "i"
