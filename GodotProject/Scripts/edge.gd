extends Node3D
class_name SquareEdge

@export var direction: Vector3
@export var color: Color = Color.ORANGE

func _ready():
	create_line(direction, color)

func create_line(direction: Vector3, color: Color):
	var line = MeshInstance3D.new()
	var mesh = CylinderMesh.new()
	mesh.height = 48
	mesh.top_radius = 0.02
	mesh.bottom_radius = 0.02
	line.mesh = mesh
	line.material_override = StandardMaterial3D.new()
	line.material_override.albedo_color = color
	line.material_override.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	
	line.rotation_degrees = direction
	add_child(line)
