extends Control

const GRID_SIZE = 6
const NUM_MINES = 10

@onready var grid_container = $GridContainer

var evil = GameManager.evil
var kawaii_cursor = load("res://cursors/kawaii_cursor.svg")
var kawaii_theme = load("res://art/themes/kawaii.tres")
var evil_cursor = load("res://cursors/evil_cursor.svg")
var evil_theme = load("res://art/themes/evil.tres")

var grid = []
@onready var mines = []

func _ready():
	initialize_grid()
	place_mines()
	ensure_min_surrounding_mines()
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
			get_tree().change_scene_to_file("res://scenes/postgame.tscn")

func check_win_condition() -> bool:
	var revealed_non_mine_cells = 0
	for x in range(GRID_SIZE):
		for y in range(GRID_SIZE):
			var cell = grid[x][y]
			if cell.disabled and not cell.is_mine:
				revealed_non_mine_cells += 1
	if revealed_non_mine_cells == GRID_SIZE * GRID_SIZE - NUM_MINES:
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
			if nx >= 0 and ny >= 0 and nx < GRID_SIZE and ny < GRID_SIZE and count_surrounding_mines(nx, ny) >= 5:
				return false
	return true

func ensure_min_surrounding_mines():
	for x in range(GRID_SIZE):
		for y in range(GRID_SIZE):
			if not grid[x][y].is_mine and count_surrounding_mines(x, y) == 0:
				place_adjacent_mine(x, y)

func place_adjacent_mine(x, y):
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			var nx = x + dx
			var ny = y + dy
			if nx >= 0 and ny >= 0 and nx < GRID_SIZE and ny < GRID_SIZE and not grid[nx][ny].is_mine and count_surrounding_mines(nx, ny) < 5:
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
				if count_surrounding_mines(x, y) > 5:
					reshuffle_needed = true
					break
			if reshuffle_needed:
				break
		if reshuffle_needed:
			clear_mines()
			place_mines()
			ensure_min_surrounding_mines()
			update_cell_counts()
		else:
			break

func clear_mines():
	for x in range(GRID_SIZE):
		for y in range(GRID_SIZE):
			grid[x][y].set_mine(false)
	mines.clear()

func _on_cell_revealed(cell, x, y):
	if cell.mine_count == 0:
		reveal_adjacent_cells(x, y)

func _on_mine_clicked():
	for x in range(GRID_SIZE):
		for y in range(GRID_SIZE):
			var cell = grid[x][y]
			cell.disabled = true
			if cell.is_mine:
				cell.texture_rect.texture = preload("res://art/Minesweeper/tilebomb.png")
			elif cell.mine_count > 0:
				cell.texture_rect.texture = cell.match_tile_texture(cell.mine_count)
	GameManager.recentflag = true

func reveal_adjacent_cells(x, y):
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			var nx = x + dx
			var ny = y + dy
			if nx >= 0 and ny >= 0 and nx < GRID_SIZE:
				var cell = grid[nx][ny]
				if not cell.disabled and not cell.is_mine:
					cell._on_pressed()

func _on_audio_stream_player_finished():
	await get_tree().create_timer(randi_range(1, 3)).timeout
	$AudioStreamPlayer.play()


func update_mine_count():
	GameManager.set_max_flags(mines.size())



func _on_resume_pressed():
	$PauseMenu.visible = false

func _on_quit_pressed():
	get_tree().quit()
