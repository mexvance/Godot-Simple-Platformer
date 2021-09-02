extends KinematicBody2D

const GRAVITY = 20
const SPEED = 30
const FLOOR = Vector2(0,-1)

var direction = 1
var velocity = Vector2()
var collisionWallCount = 0
var is_dead = false

func ready():
	pass

func dead():
	is_dead = true
	
	velocity = Vector2(0,0)
	$AnimatedSprite.play("dead")
	yield($AnimatedSprite, "animation_finished")
	queue_free()
	
	
		
func _physics_process(delta):
	if is_dead == false:
		velocity.x = SPEED * direction
		velocity.y += GRAVITY
		$AnimatedSprite.play("move")
		
		if is_on_wall():
			collisionWallCount += 1
			if (collisionWallCount >= 5):
				collisionWallCount = 0
				direction = direction * -1
				$RayCast2D.position.x *= -1
				if (direction < 0):
					$AnimatedSprite.flip_h = true
				else:
					$AnimatedSprite.flip_h = false
		
		if $RayCast2D.is_colliding() == false:
			direction *= -1
			$RayCast2D.position.x *= -1
			
			
		velocity = move_and_slide(velocity, FLOOR)
	pass # Replace with function body.
