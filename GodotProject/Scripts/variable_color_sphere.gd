extends MeshInstance3D
class_name VariableColorSphere

@export var sphere_color: Color = Color.ORANGE

func _ready():
	var mat = material_override
	if mat == null:
		mat = StandardMaterial3D.new()
		material_override = mat

	mat.albedo_color = sphere_color
	mat.specular = 0.8
	mat.shininess = 64

func updateColor(newColor: Color):
	var mat = material_override
	if mat and mat is StandardMaterial3D:
		mat.albedo_color = newColor
