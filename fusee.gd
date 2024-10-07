extends Sprite2D

const SQUISH_AMOUNT = 0.45  # Le facteur de squish (1.0 = normal, <1.0 = compression)
const SQUISH_TIME = 0.150    # Temps pour animer le squish

var is_waiting_for_player_interaction = false
const duration_to_squish_in_seconds = 0.2
var is_squishing = false
var original_scale:  Vector2
var squish_timer = 0.0
var original_color : Color

func _ready() -> void:
	original_color = Color(1.0, 1.0, 1.0, 1.0)
	original_scale = self.scale
	$ParticlesFire.emitting = false
	$ParticlesFumee.emitting = false

func _process(delta: float) -> void:
	# Déplacer la tronconneuse
	if Input.is_action_just_pressed("ui_accept"):
		if is_waiting_for_player_interaction:
			get_in_fusee()
			
	if is_squishing:
		apply_squish_effect(delta)
	else:
		reset_squish_effect(delta)
		
func get_in_fusee():
	get_parent().get_node("GUI").decolle_batard()

func apply_squish_effect(delta: float) -> void:
	squish_timer += delta
	
	# Compression sur l'axe Y et étirement sur l'axe X
	var new_scale = original_scale
	new_scale.y = lerp(original_scale.y, original_scale.y-0.02, squish_timer / SQUISH_TIME)
	new_scale.x = lerp(original_scale.x, original_scale.x-0.02, squish_timer / SQUISH_TIME)
	
	self.scale = new_scale
	
	if squish_timer >= SQUISH_TIME:
		squish_timer = 0.0  # Réinitialiser le timer pour répéter l'effet

func reset_squish_effect(delta: float) -> void:
	squish_timer += delta
	
	# Revenir à l'échelle normale
	var new_scale = self.scale
	new_scale = original_scale
	self.scale = new_scale
	
	if squish_timer >= SQUISH_TIME:
		squish_timer = 0.0  # Réinitialiser le timer pour le squish suivant


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == 'Player'):
		toggle_wait_for_interaction()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if (body.name == 'Player'): 
		toggle_wait_for_interaction()

func toggle_wait_for_interaction():
	if get_parent()._get_level() < 4:
		return
	
	is_waiting_for_player_interaction = !is_waiting_for_player_interaction
	
	if (is_waiting_for_player_interaction):
		self.modulate = Color(1.3, 1.3, 1.3, 1.0)  # Rendre le sprite plus clair
		squish_tree()
	else:
		self.modulate = original_color  # Revenir à la couleur normale

func squish_tree() -> void:
	is_squishing = true
	var timer: Timer = Timer.new()
	timer.wait_time = duration_to_squish_in_seconds
	timer.one_shot = true;
	timer.connect('timeout', func ():
		timer.stop();
		timer.queue_free();
		is_squishing = false
	);
	add_child(timer);
	timer.start();

func decollage() -> void:
	$DecollagePlayer.play()
	$ParticlesFumee.emitting = true
	
	var start_fire = 4.5
	
	var timer: Timer = Timer.new()
	timer.wait_time = start_fire
	timer.one_shot = true;
	timer.connect('timeout', func ():
		timer.stop();
		timer.queue_free();
		$ParticlesFire.emitting = true
		$Sprite2D.start_shake()
		self.set_z_index(4000)
		
		var tween = create_tween()
		tween.tween_property(self, "position", self.position - Vector2(0, 1600), 10).set_ease(Tween.EASE_IN)
	)
	
	add_child(timer)
	timer.start()
	
