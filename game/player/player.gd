extends KinematicBody2D

signal use_sword(active)
const WALK_SPEED = 192.0
const MAX_SWORD_TIME = 0.1875
var _just_pressed_sword = false
var _using_sword = false
var _sword_time = 0.0

func _ready():
	emit_signal("use_sword", false)
	set_fixed_process(true)

func _fixed_process(delta):
	_handle_input(delta)
	_update_sword(delta)

func _handle_input(delta):
	var up = Input.is_action_pressed("move_up")
	var down = Input.is_action_pressed("move_down")
	var left = Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")
	var sword = Input.is_action_pressed("use_sword")
	if (left and not right):
		move(Vector2(-WALK_SPEED * delta, 0.0))
		set_rot(PI / 2.0)
	elif (right and not left):
		move(Vector2(WALK_SPEED * delta, 0.0))
		set_rot(PI / -2.0)
	if (up and not down):
		move(Vector2(0.0, -WALK_SPEED * delta))
		set_rot(0.0)
	elif (down and not up):
		move(Vector2(0.0, WALK_SPEED * delta))
		set_rot(PI)
	if (sword):
		if (not _just_pressed_sword):
			_just_pressed_sword = true
			_using_sword = true
			emit_signal("use_sword", true)
	else:
		_just_pressed_sword = false

func _update_sword(delta):
	if (_using_sword):
		_sword_time += delta
		if (_sword_time >= MAX_SWORD_TIME):
			_using_sword = false
			_sword_time = 0.0
			emit_signal("use_sword", false)
