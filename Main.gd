extends Node

export(PackedScene) var mob_scene
var score
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	if not $SaveGame.savegame.file_exists($SaveGame.save_path):
		$SaveGame.create_save()
	set_up_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_up_game():
	$HUD.show()
	$Player.hide()

func game_over():
	save_record()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Music.stop()
	$DeathSound.play()
	$HUD.show_game_over()
	var bs = $SaveGame.read_savegame()
	if bs < score:
		$SaveGame.save(score)
	
func save_record():
	pass

func new_game():
	score = 0
	$Player.show()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()


func _on_MobTimer_timeout():
	if score != 0 and score % 15 == 0:
		$MobTimer.wait_time * 0.9
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instance()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_HUD_player_grey():
	$Player.animation_up = "up"
	$Player.animation_walk = "walk"
	$Player/AnimatedSprite.animation = "up"


func _on_HUD_player_red():
	$Player.animation_up = "up_red"
	$Player.animation_walk = "walk_red"
	$Player/AnimatedSprite.animation = "up_red"


func _on_HUD_show_best_score():
	var bs = $SaveGame.read_savegame()
	var format_string = "Your Best Score is: %s"
	$CanvasLayer/BestRecodPopup.dialog_text = format_string % bs
	$CanvasLayer/BestRecodPopup.window_title = "Best Score"
	$CanvasLayer/BestRecodPopup.popup_centered()
