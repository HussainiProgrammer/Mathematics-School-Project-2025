extends Node3D
class_name CrossedSphere

@onready var sphere: VariableColorSphere = $Sphere

func updateSphere(newScale: float, newColor: Color):
	sphere.updateColor(newColor)
	sphere.scale = Vector3(newScale, newScale, newScale)
