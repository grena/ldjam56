extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var windowSize = DisplayServer.window_get_size();
	var windowSize = get_viewport().get_visible_rect().size
	const assetHeight = 3608
	const assetWidth = 2304
	var scale = float(windowSize.y) / assetHeight
	self.scale = Vector2(scale, scale)
	var resizedAssetWidth = scale * assetWidth
	self.global_position.x = windowSize.x - resizedAssetWidth
	
	const mixerCenter = Vector2(1688, 338);
	var position = mixerCenter * scale;
	$MixerCenter.global_position = Vector2(position.x + windowSize.x - resizedAssetWidth, position.y)
