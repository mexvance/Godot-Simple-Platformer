extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const ACCELERATION = 50
const MAX_SPEED = 200
const JUMP_HEIGHT = -570
const WALL_JUMP_HEIGHT = -450
const WALL_SLIDE_AMT = 50
var motion = Vector2()
var attacking = false
var direction = 1
var is_dead = false

const FIREBALL = preload("res://Fireball.tscn")
export(String, FILE, "*.tscn") var world_scene

func _physics_process(delta):
	
	checkCollision()
	
	var friction = false
	var on_wall = false
	var on_floor
	var jump_motion = ""
	
	motion.y += GRAVITY	
	if is_dead == false:
			
		if Input.is_action_pressed("ui_right"):
			if attacking == false:
				direction = 1
				setHorizontalPhysics()
				
		elif Input.is_action_pressed("ui_left"):
			if attacking == false:
				direction = -1
				setHorizontalPhysics()
				
		else:
			friction = true
			if attacking == false:
				$Sprite.play('Idle')
				
				
		if is_on_floor():
			on_floor = true
	
		else:
			if attacking == false:
				if motion.y < 0:
					$Sprite.play('Jump')
				else:
					$Sprite.play('Fall')
			if friction == true:
				motion.x = lerp(motion.x,0,.05)
				
			if is_on_wall():
				on_wall = true
				
		if attacking == false:
			var motionvar = calculateJump(on_wall, on_floor, motion)
			if motionvar != null:
				motion.x = motionvar.x
				motion.y = motionvar.y
		if friction == true:
			motion.x = lerp(motion.x,0,.2)			
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
			
	
	motion = move_and_slide(motion, UP)		
func calculateJump(on_wall, on_floor, motion):
	if on_wall:
		if motion.y > 0:
			motion.y = WALL_SLIDE_AMT
			
	if Input.is_action_just_pressed("ui_up"):
		if on_wall:
			motion.y = WALL_JUMP_HEIGHT
			if direction == 1:
				motion.x = -600
			else:
				motion.x = 600	
		elif on_floor:
			motion.y = JUMP_HEIGHT
			
	return motion
		
func setHorizontalPhysics():
	if direction == 1:
		$Sprite.flip_h = false
		motion.x = min(motion.x + ACCELERATION*direction,MAX_SPEED*direction)
	else:
		$Sprite.flip_h = true
		motion.x = max(motion.x + ACCELERATION*direction,MAX_SPEED*direction)
	if sign($Position2D.position.x) == -direction:
		$CollisionShape2D.position.x *= -1
		$Position2D.position.x *= -1
	$Sprite.play('Run')
	
func checkCollision():
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			var collider = get_slide_collision(i).collider.name
			if "Spikes" == collider or "Enemy" == collider or "Enemy2" == collider or "Enemy3" == collider:
				dead()		

func dead():
	is_dead = true
	motion = Vector2(0,0)
	add_collision_exception_with(get_parent().get_node("Enemy"))
	add_collision_exception_with(get_parent().get_node("Enemy2"))
	add_collision_exception_with(get_parent().get_node("Enemy3"))
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
