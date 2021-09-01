extends Area2D

const SPEED = 400
var velocity = Vector2()


func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	emit_signal("speed", SPEED)
	velocity.x = SPEED * delta
	translate(velocity)
	$AnimatedSprite.play("shoot")


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
