extends KinematicBody2D

signal dead(enemy)
const MOVE_SPEED = 64.0
const UP = "up"
const DOWN = "down"
const LEFT = "left"
const RIGHT = "right"
const IDLE = "_idle"
const MOVE = "_move"
const DIRECTIONS = {
	UP: Vector2(0.0, -1.0),
	DOWN: Vector2(0.0, 1.0),
	LEFT: Vector2(-1.0, 0),
	RIGHT: Vector2(1.0, 0)
}
var _current_action = _make_action(null, null)

func _ready():
	_set_action(_decide_next_action())
	set_fixed_process(true)

func _fixed_process(delta):
	_set_action(call(_current_action.type, delta))

func _set_action(next_action):
	if (next_action.type != _current_action.type or next_action.dir != _current_action.dir):
		_current_action = next_action
		if (has_method("_enter" + next_action.type)):
			call("_enter" + next_action.type)
		if (has_method("_exit" + next_action.type)):
			call("_exit" + next_action.type)

func _move(delta):
	if (not _current_action.has("time")):
		_current_action.time = {
			"current": 0.0,
			"duration": rand_range(0.75, 1.0)
		}
		_face(_current_action.dir)
	move(DIRECTIONS[_current_action.dir] * MOVE_SPEED * get_fixed_process_delta_time())
	_current_action.time.current += get_fixed_process_delta_time()
	if (_current_action.time.current >= _current_action.time.duration):
		return _decide_next_action()
	return _current_action

func _decide_next_action():
	var possible_directions = []
	var space_state = get_world_2d().get_direct_space_state()
	for dir in DIRECTIONS.keys():
		var vec = DIRECTIONS[dir]
		var result = space_state.intersect_ray(get_global_pos(), get_global_pos() + (vec * 1024.0), [self], 1)
		if (not result.empty() and result.has("collider")):
			if (result.collider.get_name() == "player"):
				return _make_action(MOVE, dir)
			elif (get_global_pos().distance_to(result.position) > 32.0):
				possible_directions.push_back(dir)
		else:
			possible_directions.push_back(dir)
	return _make_action(MOVE, possible_directions[randi() % possible_directions.size()])

func _make_action(type, dir):
	return {"type": type, "dir": dir}

func _face(dir):
	if (dir == UP):
		set_rot(0.0)
	elif (dir == DOWN):
		set_rot(PI)
	elif (dir == LEFT):
		set_rot(PI / 2.0)
	elif (dir == RIGHT):
		set_rot(PI / -2.0)
