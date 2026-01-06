extends Node3D
class_name Axes3D

func _ready():
	create_axis(Vector3(90, 0, 0), Color.RED)  # X-axis (Red)
	create_axis(Vector3(0, 90, 0), Color.GREEN)  # Y-axis (Green)
	create_axis(Vector3(0, 0, 90), Color.BLUE)  # Z-axis (Blue)

func create_axis(direction: Vector3, color: Color):
	var axis = MeshInstance3D.new()
	var mesh = CylinderMesh.new()
	mesh.height = 48
	mesh.top_radius = 0.02
	mesh.bottom_radius = 0.02
	axis.mesh = mesh
	axis.material_override = StandardMaterial3D.new()
	axis.material_override.albedo_color = color
	axis.material_override.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	
	axis.rotation_degrees = direction
	add_child(axis)
