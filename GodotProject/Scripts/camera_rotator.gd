extends Node3D
class_name CameraRotator

func _physics_process(delta: float) -> void:
	rotation_degrees.y += 5 * delta
	if Input.is_action_just_pressed("quit"):
		get_tree().change_scene_to_file("res://Scenes/mainmenu.tscn")
	
	# Debugging:
	#rotation_degrees.y += 30 * delta
	#rotation_degrees.x -= 90 * delta


func _on_backbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/mainmenu.tscn")


func _on_check_1_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.
