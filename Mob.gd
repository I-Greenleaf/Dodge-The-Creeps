extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
# Array of strings ["walk", "swim", "fly"] in some order
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_visitble_on_screen_notifier_2d_screen_exited():
	queue_free()
