extends Area2D

func _physics_process(delta):
	
	pass


func _on_Enemy_body_entered(body):
	if body.name == "Player":
		get_tree().reload_current_scene()
	pass # Replace with function body.
