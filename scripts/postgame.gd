extends Control

var full : bool
var one : bool
var two : bool
var three : bool
var four : bool
var five : bool

func _physics_process(_delta):
	if Input.is_action_just_pressed("one"):
		$AnimationPlayer.play("fulltoone")
	if Input.is_action_just_pressed("two"):
		$AnimationPlayer.play("onetotwo")
	if Input.is_action_just_pressed("three"):
		$AnimationPlayer.play("twotothree")
	if Input.is_action_just_pressed("four"):
		$AnimationPlayer.play("threetofour")
	if Input.is_action_just_pressed("five"):
		$AnimationPlayer.play("fourtofive")
	if Input.is_action_just_pressed("fail"):
		$AnimationPlayer.play("final_fail")
