extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const ACCELERATION = 50
const MAX_SPEED = 200
const JUMP_HEIGHT = -550
const WALL_JUMP_HEIGHT = -450
const WALL_SLIDE_AMT = 50
var motion = Vector2()

const FIREBALL = preload("res://Fireball.tscn")

func _physics_process(delta):
	var friction = false
	var on_wall = false
	#Note that jump_motion is probably not the right way
	#to handle the direction the wall is facing to set the "bounce"
	#of the character off the wall, refactor?
	var jump_motion = ""
	
	motion.y += GRAVITY
		
	if Input.is_action_pressed("ui_right"):
		jump_motion = "right"
		$Sprite.flip_h = false
		motion.x = min(motion.x + ACCELERATION,MAX_SPEED)
		$Sprite.play('Run')
	elif Input.is_action_pressed("ui_left"):
		jump_motion = "left"
		$Sprite.flip_h = true
		motion.x -= ACCELERATION
		motion.x = max(motion.x - ACCELERATION,-MAX_SPEED)
		$Sprite.play('Run')
	else:
		friction = true
		$Sprite.play('Idle')
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
		if friction == true:
			motion.x = lerp(motion.x,0,.2)
	else:
		#if Input.is_action_just_pressed("ui_up"):
		#	motion.y = JUMP_HEIGHT
		if motion.y < 0:
			$Sprite.play('Jump')
		else:
			$Sprite.play('Fall')
		if friction == true:
			motion.x = lerp(motion.x,0,.05)
			
		if is_on_wall():
			print("on Wall")
			on_wall = true
			if motion.y > 0:
				motion.y = WALL_SLIDE_AMT
			if Input.is_action_just_pressed("ui_up"):
				motion.y = WALL_JUMP_HEIGHT
				if jump_motion == "right":
					motion.x = -600
				else:
					motion.x = 600

		
		
	#Fireball Creation
	if Input.is_action_just_pressed("ui_focus_next"):
		var fireball = FIREBALL.instance()
		get_parent().add_child(fireball)
		fireball.position = $Position2D.global_position
		
	motion = move_and_slide(motion, UP)

	

export(String, FILE, "*.tscn") var world_scene
	
func _on_Checkpoint_body_entered(body):
	print(body.name)
	if body.name == "Player":
		get_tree().change_scene(world_scene)
	pass
