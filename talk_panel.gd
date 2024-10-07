extends ColorRect
class_name TalkPanelRect

var texts_to_write = [];
var chars_to_write = '';
var should_finish_the_line = false;
@onready var original_fusee_position = $FuseeRect.global_position
@onready var original_fusee_rotation = $FuseeRect.rotation
@onready var original_jack_position = $JackRect.global_position

func _process(delta: float) -> void:
	var percentage = $PopFuseeTimer.time_left / $PopFuseeTimer.wait_time
	$FuseeRect.global_position.y = original_fusee_position.y + percentage * 300
	var percentage2 = $PopJackTimer.time_left / $PopJackTimer.wait_time
	$JackRect.global_position.y = original_jack_position.y + percentage2 * 300

func hide_jack():
	$JackRect.visible = false

func show_jack():
	$JackRect.visible = true

func is_saying_something():
	return texts_to_write.size() > 0 || chars_to_write.length() > 0;

func finish_the_line():
	should_finish_the_line = true

func play_random_cortana_voice():
	var cortana_voix = [
		$CortanaPlayer1,
		$CortanaPlayer2,
		$CortanaPlayer3,
		$CortanaPlayer4,
		$CortanaPlayer5,
	]
	cortana_voix.shuffle()
	var voix = cortana_voix.pop_front();
	voix.play();

func display_letters(text):
	$Text.text = $Text.text + text

func _write_letter():
	var first_letter = chars_to_write.substr(0, 1);
	if first_letter == '*':
		first_letter = '[color=yellow]'
	elif first_letter == '+':
		first_letter = '[/color]'
	chars_to_write = chars_to_write.substr(1);
	$Text.text = $Text.text + first_letter

func write_letter(timer):
	if (chars_to_write.length() > 0):
		if should_finish_the_line:
			while(chars_to_write.length() > 0):
				_write_letter();
			should_finish_the_line = false
			_move_fusee();
		else:
			_move_fusee();
			_write_letter();
		
	else:
		timer.stop();
		timer.queue_free();
		
		var time_for_next_line = 0.5
		var timerToNextLine: Timer = Timer.new()
		timerToNextLine.wait_time = time_for_next_line;
		timerToNextLine.one_shot = true;
		timerToNextLine.connect('timeout', self.display_next_line);
		add_child(timerToNextLine);
		timerToNextLine.start();

func display_next_line():
	if texts_to_write.size() > 0:
		var next_line = texts_to_write[0]
		self.chars_to_write = next_line
		texts_to_write = texts_to_write.slice(1)
		var time_per_letter = 0.05
		var timer: Timer = Timer.new()
		timer.wait_time = time_per_letter;
		timer.one_shot = false;
		self.play_random_cortana_voice()
		timer.connect('timeout', func (): self.write_letter(timer));
		add_child(timer);
		timer.start();
	else:
		self.run_yeah()

func affiche_dialog(texts: Array):
	self.pop_fusee();
	self.hide_jack();
	self.texts_to_write = texts;
	$Text.text = "[center]"
	
func run_yeah():
	$JackRect.global_position.y = 10000
	self.show_jack();
	self.pop_jack();
	$JackDitOkPlayer.play();

func _move_fusee():
	var rand_pos = 2
	$FuseeRect.global_position = original_fusee_position + Vector2(
		randf_range(-rand_pos, rand_pos),
		randf_range(-rand_pos, rand_pos)
	)
	var rand_rot = 0.01
	$FuseeRect.rotation = original_fusee_rotation + randf_range(-rand_rot, rand_rot) 

func pop_fusee():
	$PopFuseeTimer.start();

func pop_jack():
	$PopJackTimer.start();

func _on_pop_fusee_timer_timeout() -> void:
	display_next_line();
	$PopFuseeTimer.stop();
