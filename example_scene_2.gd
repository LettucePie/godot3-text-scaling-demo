extends Node

export(Vector2) var resolution = Vector2(1000, 600)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().set_screen_stretch(
			SceneTree.STRETCH_MODE_VIEWPORT, 
			SceneTree.STRETCH_ASPECT_KEEP, 
			resolution, 
			1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
