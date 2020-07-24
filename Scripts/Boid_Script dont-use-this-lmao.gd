extends RigidBody2D

var max_velocity = 10000
var detector : Area2D
var orientation

func _ready():
	detector = self.get_node("Detector")
	
	randomize()
	orientation = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()


func _physics_process(delta):
	var overlapping_bodies = detector.get_overlapping_bodies()

	orientation = orientation.move_toward((alignment_direction(overlapping_bodies) + cohesion_direction(overlapping_bodies)) / 2, deg2rad(3)).normalized()
	orientation = orientation.move_toward(separation_direction(overlapping_bodies), deg2rad(3)).normalized()
	orientation = orientation.move_toward(avoid_wall_direction(), deg2rad(10)).normalized()
	
	self.linear_velocity = orientation * delta * max_velocity
	self.rotation = orientation.angle() + deg2rad(90)


func avoid_wall_direction():
	var space_state = get_world_2d().direct_space_state
	var collisions = []
	
	for i in range(15):
		var ray_direction = orientation.rotated(deg2rad(ceil(float(i)/2) * (i%2*2-1) * 20))
		var collision = space_state.intersect_ray(self.position, self.position + ray_direction*150, [], 1)
		if not collision:
			return ray_direction
		else:
			collisions.append({"ray_direction": ray_direction, "position": collision.position})
	
	var ret
	for i in collisions:
		if not ret:
			ret = i
		else:
			if self.position.distance_to(i["position"]) < self.position.distance_to(ret["position"]):
				ret = i
	return ret["ray_direction"]


func separation_direction(detected_bodies):
	if len(detected_bodies) > 1:
		var nearest_body
		for i in detected_bodies:
			if not nearest_body:
				nearest_body = i
			else:
				if self.position.distance_to(i["position"]) < self.position.distance_to(nearest_body["position"]) and i != self:
					nearest_body = i
		
		return (nearest_body.position - self.position).normalized()
	else:
		return orientation


func alignment_direction(detected_bodies):
	var sum = Vector2.ZERO
	var count = 0
	for i in detected_bodies:
		if i is RigidBody2D and i != self:
			var rotation_vector = Vector2(cos(i.rotation), sin(i.rotation))
			sum += rotation_vector / self.position.distance_to(rotation_vector)
			count += 1
	
	if count == 0: 
		count = 1
		
	return (sum/count).normalized()


func cohesion_direction(detected_bodies):
	var sum = Vector2.ZERO
	var count = 0
	for i in detected_bodies:
		if i is RigidBody2D and i != self:
			sum += i.position / self.position.distance_to(i.position)
			count += 1
	
	if count == 0: 
		count = 1
		
	return (sum/count).normalized()
