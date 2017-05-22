extends Node2D

func _ready():
	print(get_node("floor").world_to_map(Vector2(960, 352)))

func _on_enemy_dead(enemy):
	enemy.queue_free()
