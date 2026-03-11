# Boids Simulation

[![Play on itch.io](https://img.shields.io/badge/Play%20on-itch.io-FA5C5C?style=for-the-badge&logo=itchdotio)](https://gargoth.itch.io/boids-simulation)

A 2D Boids simulation built with the Godot Engine (v3.x). This project implements Craig Reynolds' flocking algorithm, simulating the collective motion of bird-like objects (boids) with interactive elements.

This was created as a small weekend side project years ago in an attempt to learn the basics of the Godot Engine.

## Features

- **Flocking Behaviors:** Boids follow the three fundamental rules of flocking:
  - **Separation:** Avoid crowding local flockmates.
  - **Alignment:** Steer towards the average heading of local flockmates.
  - **Cohesion:** Steer to move toward the average position of local flockmates.
- **Interactive Controls:**
  - **Left Click:** Spawn a cluster of new boids at the mouse cursor.
  - **Right Click:** Place static circular obstacles that boids will avoid.
- **Screen Wrapping:** Boids seamlessly wrap around the edges of the screen (1024x600).
- **Physics-Based Movement:** Utilizes Godot's `RigidBody2D` for smooth, force-driven movement.

## Getting Started

### Prerequisites
- [Godot Engine 3.x](https://godotengine.org/download) (GLES2 recommended).

### Running the Project
1. Clone this repository.
2. Open Godot and import the `project.godot` file.
3. Press **F5** (or the Play button) to run the `Main.tscn` scene.

## Project Structure

- `Scripts/`:
  - `Boid_Script.gd`: Core logic for boid movement, neighbor detection, and flocking forces.
  - `Boid_Container.gd`: Handles the initial spawning and mouse-driven creation of boids.
  - `Circle_Container.gd`: Manages the placement of static obstacles.
- `Packed Scenes/`:
  - `Boid.tscn`: The boid entity, including its sprite and detection area.
  - `Circle.tscn`: The static obstacle entity.
  - `Wall Container.tscn`: For boundary/obstacle management.
- `Sprites/`: Contains the visual assets for boids and obstacles.

## How it Works

The simulation uses a `Detector` (Area2D) on each boid to keep track of neighboring bodies. In every physics frame, it calculates the necessary forces to maintain separation, alignment, and cohesion based on its current neighbors. These forces are then applied to the boid's `applied_force` property.

- **Separation Weight:** Higher priority for close-range avoidance.
- **Alignment Weight:** Influences the boid's velocity to match its neighbors.
- **Cohesion Weight:** Gently pulls boids toward the center of the local flock.
