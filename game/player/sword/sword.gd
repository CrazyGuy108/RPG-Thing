extends Area2D

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if (body.get_name().begins_with("enemy") and is_visible()):
			body.queue_free()

func _on_player_use_sword(active):
	set_hidden(not active)
