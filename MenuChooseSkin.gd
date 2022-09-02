extends CanvasLayer
signal choose_grey
signal choose_red


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PlayerGrey_pressed():
	emit_signal("choose_grey")


func _on_PlayerRed_pressed():
	emit_signal("choose_red")
