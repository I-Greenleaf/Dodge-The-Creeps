extends CanvasLayer

signal start_game
var score_shown = true


func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over(scores):
	show_message("Game Over")
	# Waits until MessageTImer counts to 0
	await $MessageTimer.timeout
	
	# Displays high scores in current session
	show_message(str("High Scores:\n", scores[-1], "\n", scores[-2], "\n", scores[-3]))
	
	await $MessageTimer.timeout
	
	
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finsih
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)
	


func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout():
	$Message.hide()
	
func flip_score():
	if score_shown:
		$ScoreLabel.show()
	else:
		$ScoreLabel.hide()
	score_shown = !score_shown
