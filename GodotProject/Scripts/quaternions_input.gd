extends ColorRect
class_name QuaternionInputContainer

var quaternion := Vector4(0, 0, 0, 1)

@onready var x_slider = $bSlider
@onready var y_slider = $cSlider
@onready var z_slider = $dSlider
@onready var w_slider = $aSlider

@onready var b: LineEdit = $b
@onready var c: LineEdit = $c
@onready var d: LineEdit = $d
@onready var a: LineEdit = $a
@onready var x: LineEdit = $xInput
@onready var y: LineEdit = $yInput
@onready var z: LineEdit = $zInput

var ignore_change: bool = false

func _ready():
	x_slider.value_changed.connect(_on_value_changed.bind("x"))
	y_slider.value_changed.connect(_on_value_changed.bind("y"))
	z_slider.value_changed.connect(_on_value_changed.bind("z"))
	w_slider.value_changed.connect(_on_value_changed.bind("w"))
	
	b.text_submitted.connect(_on_line_value_changed.bind("x"))
	c.text_submitted.connect(_on_line_value_changed.bind("y"))
	d.text_submitted.connect(_on_line_value_changed.bind("z"))
	a.text_submitted.connect(_on_line_value_changed.bind("w"))
	
	x.text_submitted.connect(_on_degree_changed.bind("x"))
	y.text_submitted.connect(_on_degree_changed.bind("z"))
	z.text_submitted.connect(_on_degree_changed.bind("y"))

func _on_value_changed(value: float, modified_component: String):
	if !ignore_change:
		ignore_change = true
		quaternion[modified_component] = value / 10000000

		var norm_squared = quaternion.x * quaternion.x + quaternion.y * quaternion.y + quaternion.z * quaternion.z + quaternion.w * quaternion.w
		if norm_squared > 0: 
			var scale = 1.0 / sqrt(norm_squared)
			quaternion *= scale

		x_slider.value = quaternion.x*10000000
		y_slider.value = quaternion.y*10000000
		z_slider.value = quaternion.z*10000000
		w_slider.value = quaternion.w*10000000

		b.text = str(quaternion.x)
		c.text = str(quaternion.y)
		d.text = str(quaternion.z)
		a.text = str(quaternion.w)
		
		x.text = str(rad_to_deg(atan2(2 * (quaternion.w * quaternion.x + quaternion.y * quaternion.z), 1 - 2 * (quaternion.x * quaternion.x + quaternion.y * quaternion.y))))
		y.text = str(rad_to_deg(asin(clamp(2 * (quaternion.w * quaternion.y - quaternion.z * quaternion.x), -1, 1))))
		z.text = str(rad_to_deg(atan2(2 * (quaternion.w * quaternion.z + quaternion.x * quaternion.y), 1 - 2 * (quaternion.y * quaternion.y + quaternion.z * quaternion.z))))
		ignore_change = false

func _on_line_value_changed(value: String, modified_component: String) -> void:
	if value.is_valid_float():
		ignore_change = true
		quaternion[modified_component] = float(value)

		var norm_squared = quaternion.x * quaternion.x + quaternion.y * quaternion.y + quaternion.z * quaternion.z + quaternion.w * quaternion.w
		if norm_squared > 0:
			var scale = 1.0 / sqrt(norm_squared)
			quaternion *= scale
			
		x_slider.value = quaternion.x*10000000
		y_slider.value = quaternion.y*10000000
		z_slider.value = quaternion.z*10000000
		w_slider.value = quaternion.w*10000000

		b.text = str(quaternion.x)
		c.text = str(quaternion.y)
		d.text = str(quaternion.z)
		a.text = str(quaternion.w)
		
		x.text = str(rad_to_deg(atan2(2 * (quaternion.w * quaternion.x + quaternion.y * quaternion.z), 1 - 2 * (quaternion.x * quaternion.x + quaternion.y * quaternion.y))))
		y.text = str(rad_to_deg(asin(clamp(2 * (quaternion.w * quaternion.y - quaternion.z * quaternion.x), -1, 1))))
		z.text = str(rad_to_deg(atan2(2 * (quaternion.w * quaternion.z + quaternion.x * quaternion.y), 1 - 2 * (quaternion.y * quaternion.y + quaternion.z * quaternion.z))))
		ignore_change = false
	
func _on_degree_changed(value: String, axis: String):
	if value.is_valid_float():
		ignore_change = true
		quaternion.w = cos(deg_to_rad(float(x.text)) / 2) * cos(deg_to_rad(float(y.text)) / 2) * cos(deg_to_rad(float(z.text)) / 2) + sin(deg_to_rad(float(x.text)) / 2) * sin(deg_to_rad(float(y.text)) / 2) * sin(deg_to_rad(float(z.text)) / 2)
		quaternion.x = sin(deg_to_rad(float(x.text)) / 2) * cos(deg_to_rad(float(y.text)) / 2) * cos(deg_to_rad(float(z.text)) / 2) - cos(deg_to_rad(float(x.text)) / 2) * sin(deg_to_rad(float(y.text)) / 2) * sin(deg_to_rad(float(z.text)) / 2)
		quaternion.y = cos(deg_to_rad(float(x.text)) / 2) * sin(deg_to_rad(float(y.text)) / 2) * cos(deg_to_rad(float(z.text)) / 2) + sin(deg_to_rad(float(x.text)) / 2) * cos(deg_to_rad(float(y.text)) / 2) * sin(deg_to_rad(float(z.text)) / 2)
		quaternion.z = cos(deg_to_rad(float(x.text)) / 2) * cos(deg_to_rad(float(y.text)) / 2) * sin(deg_to_rad(float(z.text)) / 2) - sin(deg_to_rad(float(x.text)) / 2) * sin(deg_to_rad(float(y.text)) / 2) * cos(deg_to_rad(float(z.text)) / 2)
	
		x_slider.value = quaternion.x*10000000
		y_slider.value = quaternion.y*10000000
		z_slider.value = quaternion.z*10000000
		w_slider.value = quaternion.w*10000000

		b.text = str(quaternion.x)
		c.text = str(quaternion.y)
		d.text = str(quaternion.z)
		a.text = str(quaternion.w)
		ignore_change = false
	
func _on_reset_button_button_down() -> void:
	quaternion = Vector4(0,0,0,1)
	
	x_slider.value = snapped(quaternion.x, 0.001)
	y_slider.value = snapped(quaternion.y, 0.001)
	z_slider.value = snapped(quaternion.z, 0.001)
	w_slider.value = snapped(quaternion.w, 0.001)

	b.text = str(snapped(quaternion.x, 0.001))
	c.text = str(snapped(quaternion.y, 0.001))
	d.text = str(snapped(quaternion.z, 0.001))
	a.text = str(snapped(quaternion.w, 0.001))
	
	x.text = str(rad_to_deg(atan2(2 * (quaternion.w * quaternion.x + quaternion.y * quaternion.z), 1 - 2 * (quaternion.x * quaternion.x + quaternion.y * quaternion.y))))
	y.text = str(rad_to_deg(asin(clamp(2 * (quaternion.w * quaternion.y - quaternion.z * quaternion.x), -1, 1))))
	z.text = str(rad_to_deg(atan2(2 * (quaternion.w * quaternion.z + quaternion.x * quaternion.y), 1 - 2 * (quaternion.y * quaternion.y + quaternion.z * quaternion.z))))
