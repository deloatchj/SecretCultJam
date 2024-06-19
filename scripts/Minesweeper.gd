extends Control

const GRID_SIZE = 6
var NUM_MINES = 8

@onready var grid_container = $GridContainer
@onready var win_banner = $WinBanner
@onready var loss_banner = $LossBanner

@export var blooddrips : Array[CompressedTexture2D]

var evil = GameManager.evil
var kawaii_cursor = load("res://cursors/kawaii_cursor.svg")
var kawaii_theme = load("res://art/themes/kawaii.tres")
var evil_cursor = load("res://cursors/evil_cursor.svg")
var evil_theme = load("res://art/themes/evil.tres")
var revealed_cells = 0
var flagmode = false

var grid = []
@onready var mines = []

func _ready():
	NUM_MINES = randi_range(5, 8)
	initialize_grid()
	place_mines()
	update_cell_counts()
	check_and_reshuffle()
	update_mine_count()
	
	if evil == false:
		Input.set_custom_mouse_cursor(kawaii_cursor)
		$Wood.modulate = Color("6b005b")
		$PauseMenu.theme = kawaii_theme
		$bloodwood.visible = false
	elif evil == true:
		Input.set_custom_mouse_cursor(evil_cursor)
		drip_here()
		$Wood.modulate = Color("3d3d3d")
		$PauseMenu.theme = evil_theme
		$bloodwood.visible = true

	if GameManager.minesweeperlosecounter == 0:
		%Handfull.visible = true
	if GameManager.minesweeperlosecounter == 1:
		%Hand1.visible = true
		%Splatter1.visible = true
	if GameManager.minesweeperlosecounter == 2:
		%Hand2.visible = true
		%Splatter2.visible = true
	if GameManager.minesweeperlosecounter == 3:
		%Hand3.visible = true
		%Splatter3.visible = true
	if GameManager.minesweeperlosecounter == 4:
		%Hand4.visible = true
		%Splatter4.visible = true
	if GameManager.minesweeperlosecounter == 5:
		%Hand5.visible = true
		%Splatter5.visible = true
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("escape"):
		$PauseMenu.visible = true
	
	if GameManager.recentflag == true:
		if Input.is_action_just_pressed("leftclick"):
			GameManager.minesweeperlosecounter += 1
			get_tree().change_scene_to_file("res://scenes/postgame.tscn")

	# Check for win condition
	if check_win_condition():
		GameManager.recentflag = false
		
		if Input.is_action_just_pressed("leftclick"):
			GameManager.minesweeperwincounter += 1
			if GameManager.minesweeperwincounter > 2:
				get_tree().change_scene_to_file("res://scenes/good_ending.tscn")
			else:
				get_tree().change_scene_to_file("res://scenes/postgame.tscn")
			

func check_win_condition() -> bool:
	var remaining_cells = (GRID_SIZE * GRID_SIZE) - revealed_cells
	var remaining_cells_minus_mines = remaining_cells - mines.size()
	if remaining_cells_minus_mines == 0:
		return true
	return false

func initialize_grid():
	grid_container.columns = GRID_SIZE
	for x in range(GRID_SIZE):
		var row = []
		for y in range(GRID_SIZE):
			var cell = preload("res://scenes/Cell.tscn").instantiate()
			grid_container.add_child(cell)
			row.append(cell)
			cell.connect("revealed", Callable(self, "_on_cell_revealed").bind(x, y))  # Connect with cell position
			cell.connect("mine_clicked", Callable(self, "_on_mine_clicked"))
		grid.append(row)

func place_mines():
	var placed_mines = 0
	while placed_mines < NUM_MINES:
		var x = randi() % GRID_SIZE
		var y = randi() % GRID_SIZE
		if not grid[x][y].is_mine and can_place_mine(x, y):
			grid[x][y].set_mine(true)
			mines.append(Vector2(x, y))
			placed_mines += 1

func can_place_mine(x, y):
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			var nx = x + dx
			var ny = y + dy
			if nx >= 0 and ny >= 0 and nx < GRID_SIZE and ny < GRID_SIZE and count_surrounding_mines(nx, ny) >= 3:
				return false
	return true

func place_adjacent_mine(x, y):
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			var nx = x + dx
			var ny = y + dy
			if nx >= 0 and ny >= 0 and nx < GRID_SIZE and ny < GRID_SIZE and not grid[nx][ny].is_mine and count_surrounding_mines(nx, ny) < 3:
				grid[nx][ny].set_mine(true)
				mines.append(Vector2(nx, ny))
				return

func count_surrounding_mines(x, y):
	var count = 0
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			var nx = x + dx
			var ny = y + dy
			if nx != x or ny != y:
				if nx >= 0 and ny >= 0 and nx < GRID_SIZE and ny < GRID_SIZE and grid[nx][ny].is_mine:
					count += 1
	return count

func update_cell_counts():
	for x in range(GRID_SIZE):
		for y in range(GRID_SIZE):
			var mine_count = 0
			for dx in range(-1, 2):
				for dy in range(-1, 2):
					var nx = x + dx
					var ny = y + dy
					if nx >= 0 and ny >= 0 and nx < GRID_SIZE and ny < GRID_SIZE and grid[nx][ny].is_mine:
						mine_count += 1
			grid[x][y].set_mine_count(mine_count)

func check_and_reshuffle():
	while true:
		var reshuffle_needed = false
		for x in range(GRID_SIZE):
			for y in range(GRID_SIZE):
				if count_surrounding_mines(x, y) > 3:
					reshuffle_needed = true
					break
			if reshuffle_needed:
				break
		if reshuffle_needed:
			clear_mines()
			place_mines()
			update_cell_counts()
		else:
			break

func clear_mines():
	for x in range(GRID_SIZE):
		for y in range(GRID_SIZE):
			grid[x][y].set_mine(false)
	mines.clear()

func _on_cell_revealed(cell, x, y):
	revealed_cells += 1  # Increment the count of revealed cells
	if cell.mine_count == 0:
		reveal_adjacent_cells(x, y)
	
	# Check for win condition
	if check_win_condition():
		show_win_banner()

func _on_mine_clicked():
	show_loss_banner()
	for x in range(GRID_SIZE):
		for y in range(GRID_SIZE):
			var cell = grid[x][y]
			cell.disabled = true
			if cell.is_mine:
				cell.texture_rect.texture = preload("res://art/Minesweeper/tilebomb.png")
			elif cell.mine_count > 0:
				cell.texture_rect.texture = cell.match_tile_texture(cell.mine_count)
	GameManager.recentflag = true
	GameManager.game_over = true

func reveal_adjacent_cells(x, y):
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			var nx = x + dx
			var ny = y + dy
			if nx >= 0 and ny >= 0 and nx < GRID_SIZE and ny < GRID_SIZE and (dx != 0 or dy != 0):
				var cell = grid[nx][ny]
				if not cell.disabled and not cell.is_mine:
					cell._on_pressed()

func _on_audio_stream_player_finished():
	await get_tree().create_timer(randi_range(1, 3)).timeout
	$AudioStreamPlayer.play()

func update_mine_count():
	GameManager.set_max_flags(mines.size())
	$Counter/Label.text = str(mines.size())

func _on_resume_pressed():
	$PauseMenu.visible = false

func _on_quit_pressed():
	get_tree().quit()

func _on_flagger_pressed():
	flagmode = !flagmode

func show_win_banner():
	$Darkener.visible =true
	win_banner.visible = true

func show_loss_banner():
	$LossBanner.theme = evil_theme
	$Darkener.visible = true
	loss_banner.visible = true

func drip_here():
	var mpos = get_global_mouse_position()
	var unit = TextureRect.new()
	unit.texture = blooddrips.pick_random()
	unit.scale.x = randf_range(2.0,3.0)
	unit.scale.y = unit.scale.x
	unit.position = mpos
	unit.mouse_filter = Control.MOUSE_FILTER_IGNORE
	unit.modulate.a = randf_range(0.5,0.8)
	unit.modulate.darkened(0.7)
	unit.rotation_degrees = randi_range(0,180)
	unit.pivot_offset = unit.size/2
	add_child(unit)
	%dripTimer.wait_time = randi_range(2,5)
	%dripTimer.start()


func _on_drip_timer_timeout():
	drip_here()
