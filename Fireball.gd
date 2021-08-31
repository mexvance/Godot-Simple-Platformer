extends Area2D

const SPEED = 100
var velocity = Vector2()


func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity.x = SPEED * delta
	translate(velocity)
