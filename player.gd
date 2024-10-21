extends Area2D
signal hit

@export var speed = 400 # pixels per sec
var screen_size # Size of the game window
var player_size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	player_size = $CollisionShape2D.shape.get_rect().size * .5
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Sets the velocity based on key inputs
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1

	if velocity.length() > 0:
		# if left/right and up/down keys, 
		#	normalizes makes the player not move faster than just one direction
		velocity = velocity.normalized() * speed 
		$AnimatedSprite2D.play() #'$' is shorthand for get_node()
	else:
		$AnimatedSprite2D.stop()
	
	# delta refers to the frame length
	position += velocity * delta 
	# clamp stops player from leaving the screen
	position = position.clamp(Vector2.ZERO+player_size/2, screen_size-player_size/2)
	
	
	# Rotating the sprite
	
	# Angled rotation
	if velocity.x != 0 and velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		if velocity.x > 0:
			if velocity.y > 0:
				$AnimatedSprite2D.rotation = 3*PI/4
			else:
				$AnimatedSprite2D.rotation = PI/4
		else:
			if velocity.y > 0:
				$AnimatedSprite2D.rotation = 5*PI/4
			else:
				$AnimatedSprite2D.rotation = 7*PI/4
	# Up/Down Rotation
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.rotation = PI if velocity.y > 0 else 0
	# Left/Right Rotation
	elif velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		if velocity.x > 0:
			$AnimatedSprite2D.rotation = PI/2
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.rotation = 3*PI/2
			$AnimatedSprite2D.flip_h = false
	


func _on_body_entered(_body):
	hide() # Player disapears after being hit
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)


	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
