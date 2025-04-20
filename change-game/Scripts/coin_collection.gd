extends Node2D

@export var count: int = 10;

@export var spawn_area: Rect2 = Rect2(Vector2(0, 0), Vector2(800, 600))  # Area to randomize positions

@export var texture: Texture2D;

func setup() -> void:
	for i in count:
		var sprite := Sprite2D.new()
		
		# Pick a random texture from the array
		sprite.texture = texture;
		
		# Randomize position within the given spawn area
		sprite.position = Vector2(
			randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
			randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
		)
		
		add_child(sprite)
