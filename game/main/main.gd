extends Node2D

func _ready():
	randomize()

func _on_up_exit_body_enter(body):
	print("up")

func _on_down_exit_body_enter(body):
	print("down")

func _on_left_exit_body_enter(body):
	print("left")

func _on_right_exit_body_enter(body):
	print("right")
