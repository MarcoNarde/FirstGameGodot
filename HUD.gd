extends CanvasLayer
signal start_game
signal player_grey
signal player_red
signal show_best_score


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")

	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	$ChoosePlayerSkin.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)


func _on_MessageTimer_timeout():
	$Message.hide()


func _on_StartButton_pressed():
	print_debug("ENTER")
	$StartButton.hide()
	$ChoosePlayerSkin.hide()
	emit_signal("start_game")


func _on_ChoosePlayerSkin_pressed():
	hide_all_HUD()
	#Show with the choose skin menu
	$MenuChooseSkin.show()

func hide_all_HUD():
	$MenuChooseSkin.hide()
	$Message.hide()
	$StartButton.hide()
	$ChoosePlayerSkin.hide()
	$ScoreLabel.hide()

func show_base_HUD():
	$Message.show()
	$StartButton.show()
	$ChoosePlayerSkin.show()
	$ScoreLabel.show()

func _on_MenuChooseSkin_choose_grey():
	hide_all_HUD()
	show_base_HUD()
	emit_signal("player_grey")


func _on_MenuChooseSkin_choose_red():
	hide_all_HUD()
	show_base_HUD()
	emit_signal("player_red")


func _on_BestScore_pressed():
	emit_signal("show_best_score")
