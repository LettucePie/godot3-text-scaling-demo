extends Node

export(Vector2) var resolution = Vector2(1000, 600)
export(Array, Resource) var dynfont_resources = []
export(Curve) var scale_curve = Curve.new()
export(float) var min_window_magnitude = 1
export(float) var max_window_magnitude = 500

var font_sizes : Array = []

func _ready():
	gather_initial_font_sizes()
	min_window_magnitude = resolution.length()
	max_window_magnitude = (resolution * 8).length()
	get_tree().connect("screen_resized", self, "scale_font")
	get_tree().set_screen_stretch(
			SceneTree.STRETCH_MODE_DISABLED, 
			SceneTree.STRETCH_ASPECT_IGNORE, 
			resolution, 
			1.0)


func gather_initial_font_sizes():
	font_sizes.clear()
	if dynfont_resources.size() > 0:
		for dynfont in dynfont_resources:
			font_sizes.append([dynfont, dynfont.get_size()])
	else:
		print("There are no assigned fonts to take care of!")


func scale_font():
	##
	## Get the New Window Size
	var new_size = OS.get_window_size()
	print("New Window Size: ", new_size)
	
	## Check if we have fonts to manage, and they've been acknowledged.
	if dynfont_resources.size() > 0 and font_sizes.size() > 0:
		
		## Get the Magnitude of the new window size.
		var size_magnitude = new_size.length()
		
		## Divide the New magnitude against the Max to get a scalar float.
		## Then interpolate that scalar into the Curve, if desired.
		var curve_percent_in = clamp(
				size_magnitude / (max_window_magnitude - min_window_magnitude),
				0.0,
				1.0)
		var curve_percent_out = scale_curve.interpolate(curve_percent_in)
		
		## Iterate through the gathered fonts, and build a max font size \
		## by multiplying their initial size.
		## Then linearly interpolate a new size using the Curve Scalar.
		for dynfont in font_sizes:
			var min_font_size = dynfont[1]
			var max_font_size = min_font_size * 2.5
			var new_font_size = lerp(min_font_size, max_font_size, curve_percent_out)
			dynfont[0].set_size(int(new_font_size))
