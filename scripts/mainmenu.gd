extends Control

var evil = GameManager.evil
@onready var lastui = $KawaiiMenu
var kawaii_cursor = load("res://cursors/kawaii_cursor.svg")
var evil_cursor = load("res://cursors/evil_cursor.svg")

func _ready():
	detect(evil)
	GameManager.current_flags = 0
	
func detect(evilstate):
	if evilstate == false:
		lastui = $KawaiiMenu
		$KawaiiMenu.visible = true
		$KawaiiAudio.play()
		Input.set_custom_mouse_cursor(kawaii_cursor)
		
		$EvilMenu.visible = false
		$EvilAudio.stop()
		
	elif evilstate == true:
		lastui = $EvilMenu
		$EvilMenu.visible = true
		$EvilAudio.play()
		Input.set_custom_mouse_cursor(evil_cursor)
		
		$KawaiiMenu.visible = false
		$KawaiiAudio.stop()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("toggle"):
		evil = !evil
	detect(evil)

func _on_quit_pressed():
	get_tree().quit()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/Minesweeper.tscn")

func _on_back_pressed():
	lastui.visible = true
	$Credits.visible = false


func _on_credits_pressed():
	$Credits/Back.theme = lastui.theme
	$Credits.visible = true
	$Credits/CreditsBG.texture = lastui.get_node("BG").texture
	lastui.visible = false
	
func _on_settings_pressed():
	$Settings/Back.theme = lastui.theme
	$Settings.visible = true
	$Settings/SettingsBG.texture = lastui.get_node("BG").texture
	lastui.visible = false

func _on_settings_back_pressed():
	lastui.visible = true
	$Settings.visible = false
