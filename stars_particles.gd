extends CPUParticles2D

func _ready() -> void:
	# Récupérer la taille de la fenêtre/écran
	var screen_size = get_viewport_rect().size
	var viewport_size = get_viewport().get_visible_rect().size	
	
	print_debug('TAILL = ' + str(viewport_size.y / 2))
	self.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	self.emission_rect_extents = Vector2(1, viewport_size.y / 2)
	self.emitting = true
