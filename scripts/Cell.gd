extends Button

signal revealed
signal mine_clicked

var is_mine = false
var mine_count = 0
var is_flagged = false

@export var unrevealedtiles : Array[CompressedTexture2D]
var texture_bomb
var texture_blob1
var texture_tile2
var texture_blob3
var texture_tile4
var texture_tile5
var texture_flag 
var texture_tilenone
var texture_gem1
var texture_tile_domino2
var texture_gem2
var texture_tile_domino3

@onready var texture_rect = $TextureRect

func _ready():
	texture_bomb = preload("res://art/Minesweeper/tilebomb.png")
	texture_blob1 = preload("res://art/Minesweeper/tileblob1.png")
	texture_tile2 = preload("res://art/Minesweeper/tile2.png")
	texture_blob3 = preload("res://art/Minesweeper/tileblob3.png")
	texture_tile4 = preload("res://art/Minesweeper/tile4.png")
	texture_tile5 = preload("res://art/Minesweeper/tile5.png")
	texture_flag = preload("res://art/Minesweeper/tileflag.png")
	texture_tilenone = preload("res://art/Minesweeper/tilenone.png")
	texture_gem1 = preload("res://art/Minesweeper/tilegem1.png")
	texture_tile_domino2 =preload("res://art/Minesweeper/tiledomino1.png")
	texture_gem2 = preload("res://art/Minesweeper/tilegem2.png")
	texture_tile_domino3 =preload("res://art/Minesweeper/tiledomino3.png")

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
			texture_rect.texture = texture_tilenone
		if mine_count == 0:
			reveal_neighbors()
		disabled = true
	emit_signal("revealed", self)

func match_tile_texture(count):
	match count:
		0:
			return texture_tilenone
		1:
			if randi() % 2 == 0:
				return texture_blob1
			else:
				return texture_gem1
		2:
			if randi() % 2 == 0:
				return texture_gem2
			else:
				return texture_tile_domino2
		3:
			if randi() % 2 == 0:
				return texture_blob3
			else:
				return texture_tile_domino3
		4:
			return texture_tile4
		5:
			return texture_tile5

func reveal_neighbors():
	pass

func _update_texture():
	if !is_mine and mine_count == 0:
		texture_rect.texture = unrevealedtiles.pick_random()
		texture_rect.pivot_offset = Vector2(64,64)
		texture_rect.rotation_degrees = [0,90,180,270,360].pick_random() + randi_range(-10,10)

func _gui_input(event):
	if event.is_action_pressed("rightclick") or (get_parent().get_parent().flagmode and event.is_action_pressed("leftclick")):
		if GameManager.game_over:
			return
		if disabled:
			return
		if is_flagged:
			# Remove the flag if already flagged
			texture_rect.texture = unrevealedtiles.pick_random()
			is_flagged = false
			GameManager.remove_flag()
		else:
			# Place the flag
			if GameManager.can_place_flag():
				texture_rect.texture = texture_flag
				is_flagged = true
				GameManager.place_flag()
		return

