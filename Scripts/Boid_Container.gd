extends Node2D


export (PackedScene) var boid
export (int) var boid_count= 50
export (int) var spawn_count = 3

func _ready():
	randomize()
	for i in range(boid_count):
		var new_boid = boid.instance()
		self.add_child(new_boid)
		new_boid.position = Vector2(rand_range(24, 1000), rand_range(30, 670))

func _input(event):
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(1):
		for i in range(spawn_count):
			var new_boid = boid.instance()
			self.add_child(new_boid)
			new_boid.position = Vector2(event.position) + Vector2(rand_range(-3, 3), rand_range(-3, 3))
