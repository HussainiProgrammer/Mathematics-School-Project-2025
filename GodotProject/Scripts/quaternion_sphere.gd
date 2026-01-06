extends MeshInstance3D
class_name QuaternionSphere

var isRotating = false
var desired_quaternion: Quaternion
@onready var a: LineEdit = $"../CanvasLayer/ColorRect/a"
@onready var b: LineEdit = $"../CanvasLayer/ColorRect/b"
@onready var c: LineEdit = $"../CanvasLayer/ColorRect/c"
@onready var d: LineEdit = $"../CanvasLayer/ColorRect/d"
@onready var controller: ColorRect = $"../CanvasLayer/ColorRect"

func _ready():
	create_sphere()
	apply_vertex_colors()

func _physics_process(delta: float) -> void:
	if isRotating: updateRotation(delta)

func create_sphere():
	var sphere = SphereMesh.new()
	sphere.radius = 1.0
	sphere.height = 2.0
	sphere.radial_segments = 64
	sphere.rings = 64
	
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(sphere, 0)
	var array_mesh = surface_tool.commit()
	
	mesh = array_mesh

func apply_vertex_colors():
	var array_mesh = mesh as ArrayMesh
	if not array_mesh:
		push_error("Mesh is not an ArrayMesh!")
		return
	
	var mesh_data_tool = MeshDataTool.new()
	mesh_data_tool.create_from_surface(array_mesh, 0)

	for i in range(mesh_data_tool.get_vertex_count()):
		var vertex = mesh_data_tool.get_vertex(i)
		var color = get_color_from_position(vertex)

		
		mesh_data_tool.set_vertex_color(i, color)

	array_mesh.clear_surfaces()
	mesh_data_tool.commit_to_surface(array_mesh)
	set_shader_material()

func get_color_from_position(v: Vector3) -> Color:
	var hue = v.x
	var saturation = v.y
	var brightness = 1
	return Color.from_hsv(hue, saturation, brightness)

func set_shader_material():
	var shader_material = ShaderMaterial.new()
	# add 'render_mode unshaded;' as the 2nd line in shader_code for removing light
	var shader_code = """
		shader_type spatial;

		varying vec4 v_color;

		void vertex() {
			v_color = COLOR;
		}

		void fragment() {
			ALBEDO = v_color.rgb;
		}
	"""

	var shader = Shader.new()
	shader.code = shader_code
	shader_material.shader = shader
	material_override = shader_material

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
	if not isRotating: startRotation(Quaternion(controller.quaternion.x, controller.quaternion.z, controller.quaternion.y, controller.quaternion.w), 3)

func _on_reset_button_button_down() -> void:
	if not isRotating: self.quaternion = Quaternion(0,0,0,1)
