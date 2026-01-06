extends Node2D
class_name ComplexNumberScene

@onready var multiplierLine: ComplexNumber = $ComplexNumbers/n1
@onready var multiplicandLine: ComplexNumber = $ComplexNumbers/n2
@onready var productLine: ComplexNumber = $ComplexNumbers/n3
@onready var dynamic_grid: Node2D = $DynamicGrid
@onready var a1: LineEdit = $CanvasLayer/ColorRect/a1
@onready var b1: LineEdit = $CanvasLayer/ColorRect/b1
@onready var a2: LineEdit = $CanvasLayer/ColorRect/a2
@onready var b2: LineEdit = $CanvasLayer/ColorRect/b2
@onready var a3: LineEdit = $CanvasLayer/ColorRect/a3
@onready var b3: LineEdit = $CanvasLayer/ColorRect/b3
@onready var camera_2d: Camera2D = $Camera2D
var viewport_size: Vector2

var is_multiplying = false
var is_multiplying2 = false
var some_tea = 0
var product_animated = false

func _ready() -> void:
	productLine.hide()
	viewport_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	if is_multiplying: updateMultiplication(delta)

func _on_back_button_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/mainmenu.tscn")
	
func _on_play_1_button_button_down() -> void:
	if !multiplierLine.animated and !multiplicandLine.is_initial_animating:
		var a = a1.text
		var b = b1.text
		
		if a.is_valid_float() and b.is_valid_float():
			multiplierLine.initialize(float(a), float(b))
			multiplierLine.startInitialAnimation(3)

		fitZoom(max(abs(multiplierLine.vector.x), abs(multiplicandLine.vector.x)), max(abs(multiplierLine.vector.y), abs(multiplicandLine.vector.y)))

func _on_clear_1_button_button_down() -> void:
	a1.clear()
	b1.clear()
	multiplierLine.reset()

func _on_play_2_button_button_down() -> void:
	if !multiplicandLine.animated and !multiplierLine.is_initial_animating:
		var a = a2.text
		var b = b2.text
		
		if a.is_valid_float() and b.is_valid_float():
			multiplicandLine.initialize(float(a), float(b))
			multiplicandLine.startInitialAnimation(3)
			productLine.initialize(float(a), float(b))
			productLine.startInitialAnimation(3)
			

			
		fitZoom(max(abs(multiplierLine.vector.x), abs(multiplicandLine.vector.x)), max(abs(multiplierLine.vector.y), abs(multiplicandLine.vector.y)))
					
func _on_clear_2_button_button_down() -> void:
	a2.clear()
	b2.clear()
	multiplicandLine.reset()
	productLine.reset()

func _on_play_button_button_down() -> void:
	if multiplierLine.animated and multiplicandLine.animated and !is_multiplying and !product_animated:
		product_animated = true
		is_multiplying = true
		productLine.show()
		productLine.startRotation(-multiplierLine.degrees, 3)
		dynamic_grid.startRotation(-multiplierLine.degrees, 3)
		productLine.startScaling(multiplierLine.vector.length(), 3)
		dynamic_grid.startScaling(multiplierLine.vector.length(), 3)
		
		var r_a = multiplierLine.vector.x*multiplicandLine.vector.x - multiplierLine.vector.y*multiplicandLine.vector.y
		var r_b = -(multiplierLine.vector.x*multiplicandLine.vector.y + multiplierLine.vector.y*multiplicandLine.vector.x)
		
		a3.text = str(r_a)
		b3.text = str(r_b)
		productLine.label.text = ""
		
		fitZoom(max(abs(multiplierLine.vector.x), abs(multiplicandLine.vector.x), abs(r_a)), max(abs(multiplierLine.vector.y), abs(multiplicandLine.vector.y), abs(r_b)))
		
func _on_clear_button_button_down() -> void:
	a1.clear()
	b1.clear()
	multiplierLine.reset()
	a2.clear()
	b2.clear()
	multiplicandLine.reset()
	a3.clear()
	b3.clear()
	productLine.reset()	
	productLine.hide()
	camera_2d.zoom = Vector2(1,1)
	product_animated = false
	#dynamic_grid.startScaling(1/dynamic_grid.dynamicLines.scale.x, 1)
	#dynamic_grid.startRotation(dynamic_grid.dynamicLines.rotation_degrees, 1)



func updateMultiplication(delta_t: float):
	#print("LOG:")
	#print(productLine.isRotating); print(productLine.isScaling); print(dynamic_grid.isRotating); print(dynamic_grid.isScaling)
	if is_multiplying2:
		some_tea += delta_t
		if some_tea >= 1.25:
			is_multiplying = false
			is_multiplying2 = false
			dynamic_grid.startScaling(1/dynamic_grid.dynamicLines.scale.x, 1)
			dynamic_grid.startRotation(dynamic_grid.dynamicLines.rotation_degrees, 1)
	
	elif !productLine.isRotating and !productLine.isScaling and !dynamic_grid.isRotating and !dynamic_grid.isScaling:
		some_tea = 0
		is_multiplying2 = true
		productLine.label.text = productLine.format_complex(float(a3.text), float(b3.text))

func fitZoom(x: float, y: float):
	var new_zoom = min(viewport_size.x/((abs(x) + 1)*2*100), viewport_size.y/((abs(y) + 1)*2*100))
	camera_2d.zoom = Vector2(new_zoom, new_zoom)
