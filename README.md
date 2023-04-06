# godot-astar-2d-grid-node
 A simple implementation of a Node for the abstract class AStar2DGrid, that can be used to implement pathfinding.
 
 <p align="center">
  <img src="https://user-images.githubusercontent.com/35619327/230246342-35f547c4-81d1-4563-82ac-4fbc83a3a2f1.png" />
</p>
 
## Preview
![image](https://user-images.githubusercontent.com/35619327/230228416-f8c07b26-a176-4230-8ff2-17583e7efdc5.png)

## Nodes
* AStar2DGridNode

### AStar2DGridNode
#### Properties
* ```AStarGrid2D grid``` _[ default: AStarGrid2D.new() ]_
* ```Vector2i grid_size``` _[ default: Vector2i(32, 32) ]_
* ```Vector2 cell_size``` _[ default: Vector2(16, 16) ]_
* ```Array[Vector2i] disabled_points``` _[ default: [ ] ]_
* ```bool enable_grid_during_play``` _[ default: false ]_

#### Methods
##### Getters & Setters
* ```Vector2i get_grid_size()```
* ```Array[Vector2i] get_disabled_points()```
* ```Vector2 get_cell_size()```
* ```void set_enable_grid_during_play(new_value: bool)```
* ```void set_grid_size(new_value: Vector2i)```
* ```void set_cell_size(new_value: Vector2)```
* ```void set_disabled_points(new_value: Array[Vector2i])```
##### Path Calculators
* ```Array calculate_point_path(from: Vector2, to: Vector2)```
* ```Array calculate_point_path_by_id(from_id: Vector2i, to_id: Vector2i)```
* ```Array calculate_id_path(from: Vector2, to: Vector2)```
* ```Array calculate_id_path_by_id(from_id: Vector2i, to_id: Vector2i)```
##### Utils
* ```void disable_point(id: Vector2i)```
* ```void enable_point(id: Vector2i)```
* ```Vector2i get_nearest_id(pos: Vector2)```
