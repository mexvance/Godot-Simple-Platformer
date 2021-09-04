extends Area2D

const SPEED = 400
var velocity = Vector2()
var direction = 1
var stopped = false

func _ready():
	pass # Replace with function body.

func set_fireball_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
		
func _physics_process(delta):
	if stopped == false:
		set_fireball_direction(direction)
		velocity.x = SPEED * delta * direction
		translate(velocity)
		$AnimatedSprite.play("shoot")



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Fireball_body_entered(body):
	velocity.x = 0
	stopped = true
	if body.get_parent().name == "Enemy":
		body.dead()
	print(body.name)
	if direction != 1:
		$AnimatedSprite.flip_h = true
	
	$AnimatedSprite.play("explode")
	yield($AnimatedSprite, "animation_finished")
	print("after animation")
	queue_free()


func _on_Fireball_area_shape_entered(area_id, area, area_shape, local_shape):
	if area.name == "Enemy":
		queue_free()
		area.queue_free()
