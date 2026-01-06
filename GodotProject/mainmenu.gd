extends Node2D

func _on_button_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/complex_numbers_scene.tscn")

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/linelander.tscn")

func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/flatlander.tscn")

func _on_button_4_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/quaternions.tscn")

func _on_button_5_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/hyper_sphere_main.tscn")
