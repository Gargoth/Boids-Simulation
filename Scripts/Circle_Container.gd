extends Node2D


export (PackedScene) var circle


func _input(event):
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(2):
		var new_circle = circle.instance()
		self.add_child(new_circle)
		new_circle.position = Vector2(event.position)
