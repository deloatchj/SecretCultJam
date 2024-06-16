extends Button

signal revealed
signal mine_clicked

var is_mine = false
var mine_count = 0
var is_flagged = false

var texture_bomb
var texture_tile0
var texture_tile1
var texture_tile2
var texture_tile3
var texture_tile4
var texture_tile5
var texture_flag 
var texture_tilenone

@onready var texture_rect = $TextureRect

func _ready():
	texture_bomb = preload("res://art/Minesweeper/tilebomb.png")
	texture_tile0 = preload("res://art/Minesweeper/tile0.png")
	texture_tile1 = preload("res://art/Minesweeper/tile1.png")
	texture_tile2 = preload("res://art/Minesweeper/tile2.png")
	texture_tile3 = preload("res://art/Minesweeper/tile3.png")
	texture_tile4 = preload("res://art/Minesweeper/tile4.png")
	texture_tile5 = preload("res://art/Minesweeper/tile5.png")
	texture_flag = preload("res://art/Minesweeper/tileflag.png")
	texture_tilenone = preload("res://art/Minesweeper/tilenone.png")

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
		0:
			return texture_tilenone
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
	if event.is_action_pressed("rightclick") or get_parent().get_parent().flagmode:
		if GameManager.game_over:
			return
		if disabled:
			return
		if is_flagged:
			# Remove the flag if already flagged
			texture_rect.texture = texture_tile0
			is_flagged = false
			GameManager.remove_flag()
		else:
			# Place the flag
			if GameManager.can_place_flag():
				texture_rect.texture = texture_flag
				is_flagged = true
				GameManager.place_flag()
		return

