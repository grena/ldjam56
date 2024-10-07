extends TextureRect

@onready var P1 = $Polygon2D
@onready var P2 = $Polygon2D2
@onready var P3 = $Polygon2D3
@onready var P4 = $Polygon2D4
@onready var P5 = $Polygon2D5
@onready var P6 = $Polygon2D6
@onready var P7 = $Polygon2D7
@onready var P8 = $Polygon2D8
@onready var P9 = $Polygon2D9

func flash():
	var time_per_tube = 0.02
	var time_before_flash = 1
	flash_display_after(P9, time_before_flash)
	flash_display_after(P8, time_before_flash + time_per_tube)
	flash_display_after(P7, time_before_flash + 2 * time_per_tube)
	flash_display_after(P6, time_before_flash + 3 * time_per_tube)
	flash_display_after(P5, time_before_flash + 4 * time_per_tube)
	flash_display_after(P4, time_before_flash + 5 * time_per_tube)
	flash_display_after(P3, time_before_flash + 6 * time_per_tube)
	flash_display_after(P2, time_before_flash + 7 * time_per_tube)
	flash_display_after(P1, time_before_flash + 8 * time_per_tube)

func flash_display_after(polygon: Polygon2D, time: float):
	var timer = Timer.new()
	timer.wait_time = time;
	timer.one_shot = true;
	timer.connect('timeout', func ():
		polygon.set_visible(true);
		var timer2 = Timer.new()
		timer2.wait_time = 0.1;
		timer2.one_shot = true;
		timer2.connect('timeout', func ():
			polygon.set_visible(false);
		);
		add_child(timer2)
		timer2.start();
		);
	add_child(timer);
	timer.start();
