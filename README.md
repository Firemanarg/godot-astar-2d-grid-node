# godot-astar-2d-grid-node
 A simple implementation of a Node for the abstract class AStar2DGrid, that can be used to implement pathfinding.

 <p align="center">
  <img src="https://user-images.githubusercontent.com/35619327/230246342-35f547c4-81d1-4563-82ac-4fbc83a3a2f1.png" />
</p>

## Preview
![image](https://user-images.githubusercontent.com/35619327/230228416-f8c07b26-a176-4230-8ff2-17583e7efdc5.png)

## Examples
* Example 01 - Simple Movement
* Example 02 - Scenery obstacles with point disable

## Nodes
* AStar2DGridNode

### AStar2DGridNode
#### Properties
##### Default
* ```AStarGrid2D grid``` _[ default: AStarGrid2D.new() ]_ _[getter, setter]_
* ```Vector2i grid_size``` _[ default: Vector2i(32, 32) ]_ _[getter, setter]_
* ```Vector2 cell_size``` _[ default: Vector2(16, 16) ]_ _[getter, setter]_
* ```Array[Vector2i] disabled_points``` _[ default: [ ] ]_ _[getter, setter]_
##### Debug
* ```bool enable_debug``` _[ default: true ]_ _[ getter, setter ]_
* ```bool debug_editor_only``` _[ default: true ]_ _[ getter, setter ]_
* ```float debug_point_size``` _[ default: 2.0 ]_ _[ getter, setter ]_
* ```float debug_point_border_size``` _[ default: 0.5 ]_ _[ getter, setter ]_
* ```Color enabled_point_fill_color``` _[ default: Color.SALMON ]_ _[ getter, setter ]_
* ```Color enabled_point_border_color``` _[ default: Color.WHITE ]_ _[ getter, setter ]_
* ```Color disabled_point_fill_color``` _[ default: Color.SLATE_GRAY ]_ _[ getter, setter ]_
* ```Color disabled_point_border_color``` _[ default: Color.WHITE ]_ _[ getter, setter ]_

#### Methods
##### Path Calculators
* ```Array calculate_point_path(from: Vector2, to: Vector2)```
* ```Array calculate_point_path_by_id(from_id: Vector2i, to_id: Vector2i)```
* ```Array calculate_id_path(from: Vector2, to: Vector2)```
* ```Array calculate_id_path_by_id(from_id: Vector2i, to_id: Vector2i)```
##### Utils
* ```void disable_point(id: Vector2i)```
* ```void enable_point(id: Vector2i)```
* ```void disable_points(ids: Array[Vector2i])```
* ```void enable_points(ids: Array[Vector2i])```
* ```Vector2i get_nearest_id(pos: Vector2)```
* ```Vector2i get_nearest_real_id(pos: Vector2)```
* ```Array[Vector2i] get_id_list_inside_rect(rect: Rect2, margin)```
* ```Array[Vector2i] get_id_list_inside_circle(origin: Vector2, radius: float, margin: float = 0.0)```
* ```Rect2 get_local_rect()```
* ```Rect2 get_global_rect()```
* ```Vector2 get_point_position```

## Credits
#### Generic RPG pack by Estudio Vaca Roxa (used in examples):
https://bakudas.itch.io/generic-rpg-pack
