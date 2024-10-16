extends Node

@export var mob_scene: PackedScene
var score
var high_scores = [0, 0, 0]

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	high_scores.push_front(score)
	high_scores.sort()
	high_scores.pop_front()
	$HUD.show_game_over(high_scores)
	
	$Music.stop()
	$DeathSound.play()
	
	
	$HUD.flip_score()
	
	
	
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.flip_score()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	$Music.play()
	get_tree().call_group("mobs", "queue_free")
	

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
	
func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene (aka a new mob)
	var mob = mob_scene.instantiate()
	
	# Chose a random location on Path2D
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	
	var direction = mob_spawn_location.rotation #+ PI / 2
	# + PI / 2 to set the mob's direction perpendicular to the path direction
	
	# Set the mob's position to a random location
	mob.position = mob_spawn_location.position
	
	# Add some randomness to the direction
	direction += randf_range(-PI/4, PI/4)
	
	mob.rotation = direction
	
	# Choose the velocity for the mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Shortens the timer to increase difficulty as the game goes on
	$MobTimer.wait_time = 10.0/(score+20)
	
	# Add mob to main scene
	add_child(mob)


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)
	
