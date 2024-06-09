extends Control

const GRID_SIZE = 6
const NUM_MINES = 10

@onready var grid_container = $GridContainer

var grid = []
var mines = []

func _ready():
	initialize_grid()
	place_mines()
	ensure_min_surrounding_mines()
	update_cell_counts()
	check_and_reshuffle()

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

func reveal_adjacent_cells(x, y):
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			var nx = x + dx
			var ny = y + dy
			if nx >= 0 and ny >= 0 and nx < GRID_SIZE and ny < GRID_SIZE:
				var cell = grid[nx][ny]
				if not cell.disabled and not cell.is_mine:
					cell._on_pressed()
