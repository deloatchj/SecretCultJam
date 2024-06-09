extends Button

signal revealed
signal mine_clicked

var is_mine = false
var mine_count = 0
var is_flagged = false  # Add a flag state

var texture_bomb
var texture_tile0
var texture_tile1
var texture_tile2
var texture_tile3
var texture_tile4
var texture_tile5
var texture_flag  # Add a variable for the flag texture

@onready var texture_rect = $TextureRect

func _ready():
	texture_bomb = preload("res://art/Minesweeper/tilebomb.png")
	texture_tile0 = preload("res://art/Minesweeper/tile0.png")
	texture_tile1 = preload("res://art/Minesweeper/tile1.png")
	texture_tile2 = preload("res://art/Minesweeper/tile2.png")
	texture_tile3 = preload("res://art/Minesweeper/tile3.png")
	texture_tile4 = preload("res://art/Minesweeper/tile4.png")
	texture_tile5 = preload("res://art/Minesweeper/tile5.png")
	texture_flag = preload("res://art/Minesweeper/tileflag.png")  # Preload the flag texture

	connect("pressed", Callable(self, "_on_pressed"))
	_update_texture()

func set_mine(value):
	is_mine = value
	_update_texture()

func set_mine_count(value):
	mine_count = value
	_update_texture()

func _on_pressed():
	if is_flagged:
		return
	if is_mine:
		texture_rect.texture = texture_bomb
		emit_signal("mine_clicked")
	else:
		if mine_count > 0:
			texture_rect.texture = match_tile_texture(mine_count)
		else:
			texture_rect.texture = texture_tile0
		if mine_count == 0:
			reveal_neighbors()
		disabled = true
	emit_signal("revealed", self)

func match_tile_texture(count):
	match count:
		1:
			return texture_tile1
		2:
			return texture_tile2
		3:
			return texture_tile3
		4:
			return texture_tile4
		5:
			return texture_tile5

func reveal_neighbors():
	pass

func _update_texture():
	if !is_mine and mine_count == 0:
		texture_rect.texture = texture_tile0

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT && event.pressed:
			if is_flagged:
				# Remove the flag if already flagged
				texture_rect.texture = texture_tile0
				is_flagged = false
			else:
				# Place the flag
				texture_rect.texture = texture_flag
				is_flagged = true
			return

func _input(event):
	if event is InputEventKey && event.pressed:
		if event.keycode == KEY_R:
			reset_game()

func reset_game():
	print("Resetting the game...")
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
