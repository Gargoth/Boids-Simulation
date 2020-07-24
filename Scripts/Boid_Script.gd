extends RigidBody2D

export (int) var max_velocity = 50
var detector : Area2D


func _ready():
	detector = self.get_node("Detector")
	self.rotation = 0.5


func _physics_process(delta):
	# orientation = orientation.move_toward(avoid_wall_direction(), deg2rad(10)).normalized()
	
	var overlapping_bodies = detector.get_overlapping_bodies()
	
	var separation = Vector2.ZERO
	var alignment = Vector2.ZERO
	var cohesion = Vector2.ZERO
	
	if len(overlapping_bodies) > 1:
		
		for i in overlapping_bodies:
			if i != self and i is RigidBody2D:
				if self.position.distance_to(i.position) < 20:
					separation -= i.position - self.position
				alignment += i.linear_velocity
				cohesion += i.position - self.position
		
		alignment /= len(overlapping_bodies)-1
		cohesion /= len(overlapping_bodies)-1
	
	if avoid_wall_direction():
		separation -= (avoid_wall_direction() - self.position)
	
	self.applied_force = ((separation + alignment/8 + cohesion/100) * delta * max_velocity)
	self.rotation = self.linear_velocity.angle() + deg2rad(90)
	self.linear_velocity = self.linear_velocity.clamped(150)
	
	if self.position.x > 1024:
		self.position.x = 0
	elif self.position.x < 0:
		self.position.x = 1024
	if self.position.y > 600:
		self.position.y = 0
	elif self.position.y < 0:
		self.position.y = 600


func avoid_wall_direction():
	var space_state = get_world_2d().direct_space_state
	var collisions = []
	
	for i in range(15):
		var ray_direction = Vector2(cos(self.rotation), sin(self.rotation)).rotated(deg2rad(ceil(float(i)/2) * (i%2*2-1) * 20))
		var collision = space_state.intersect_ray(self.position, self.position + ray_direction*50, [], 1)
		if collision:
			collisions.append({"ray_direction": ray_direction, "position": collision.position})
	
	var ret
	for i in collisions:
		if not ret:
			ret = i
		else:
			if self.position.distance_to(i["position"]) < self.position.distance_to(ret["position"]):
				ret = i
				
	if ret:
		return ret["position"]
