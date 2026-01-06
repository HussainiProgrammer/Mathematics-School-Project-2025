extends Node3D

func _process(delta: float) -> void:
	if Input.is_action_pressed("test1"): rotation_degrees.x += 15*delta
	if Input.is_action_pressed("test2"): rotation_degrees.x -= 15*delta
	if Input.is_action_pressed("test3"): rotation_degrees.y += 15*delta
	if Input.is_action_pressed("test4"): rotation_degrees.y -= 15*delta
	
	
