extends RigidBody2D

var type
@export var bullet_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	# Array of strings ["walk", "swim", "fly"] in some order
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	type = mob_types[randi() % mob_types.size()]
	$AnimatedSprite2D.play(type)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func shoot():
	if type == "swim":
		# Creates a new bullet
		var bullet = bullet_scene.instantiate()
		# Postion and Rotation already match the mob's; no need to set them

		# Bullet travels at double the mob's speed
		var velocity = linear_velocity * 2
		bullet.linear_velocity = velocity.rotated(bullet.rotation)
		
		add_child(bullet)
