extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const ACCELERATION = 50
const MAX_SPEED = 200
const JUMP_HEIGHT = -550
const WALL_JUMP_HEIGHT = -450
const WALL_SLIDE_AMT = 50
var motion = Vector2()
var attacking = false
var direction = 1
var is_dead = false

const FIREBALL = preload("res://Fireball.tscn")
export(String, FILE, "*.tscn") var world_scene

func _physics_process(delta):
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var spikes = get_parent().get_node("Spikes")
		if collision.collider == spikes:
			get_tree().reload_current_scene()
	var friction = false
	var on_wall = false
	#Note that jump_motion is probably not the right way
	#to handle the direction the wall is facing to set the "bounce"
	#of the character off the wall, refactor?
	var jump_motion = ""
	
	motion.y += GRAVITY	
	if is_dead == false:
			
		if Input.is_action_pressed("ui_right"):
			if attacking == false:
				direction = 1
				$Sprite.flip_h = false
				motion.x = min(motion.x + ACCELERATION,MAX_SPEED)
				
				if sign($Position2D.position.x) == -1:
					$CollisionShape2D.position.x *= -1
					$Position2D.position.x *= -1
				$Sprite.play('Run')
		elif Input.is_action_pressed("ui_left"):
			if attacking == false:
				direction = -1
				$Sprite.flip_h = true
				motion.x -= ACCELERATION
				motion.x = max(motion.x - ACCELERATION,-MAX_SPEED)
				if sign($Position2D.position.x) == 1:
					$CollisionShape2D.position.x *= -1
					$Position2D.position.x *= -1
				$Sprite.play('Run')
		else:
			friction = true
			if attacking == false:
				$Sprite.play('Idle')
		if is_on_floor():
			if Input.is_action_just_pressed("ui_up"):
				if attacking == false:
					motion.y = JUMP_HEIGHT
			if friction == true:
				motion.x = lerp(motion.x,0,.2)
		else:
			#if Input.is_action_just_pressed("ui_up"):
			#	motion.y = JUMP_HEIGHT
			if attacking == false:
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
					if direction == 1:
						motion.x = -600
					else:
						motion.x = 600			
						
		#Fireball Creation
		if Input.is_action_just_pressed("ui_focus_next") && attacking == false && on_wall == false:
			attacking = true
			if is_on_floor():
				motion.x = 0
			var fireball = FIREBALL.instance()
			$Sprite.play("Shoot")
			yield($Sprite, "animation_finished")
			fireball.set_fireball_direction(sign($Position2D.position.x))
			get_parent().add_child(fireball)
			fireball.position = $Position2D.global_position
			
		

		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Enemy" in get_slide_collision(i).collider.name:
					dead()		
	motion = move_and_slide(motion, UP)		

func dead():
	is_dead = true
	motion.x = 0
	$Sprite.play("Death")
	$Timer.start()
	
func _on_Checkpoint_body_entered(body):
	print(body.name)
	if body.name == "Player":
		get_tree().change_scene(world_scene)
	pass


func _on_Sprite_animation_finished():
	attacking = false


func _on_Timer_timeout():
	get_tree().reload_current_scene()
	pass # Replace with function body.
