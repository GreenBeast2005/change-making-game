extends Node2D

@export var coins: Array[float] = [];

@onready var h_box_container: HBoxContainer = $Sprite2D/HBoxContainer
@onready var sprite_2d: Sprite2D = $Sprite2D

var starting_x: int;

func _ready() -> void:
	h_box_container._setup_buttons(coins);
	starting_x = sprite_2d.position.x;

signal coin_selected(coin_value: float);

func _on_h_box_container_coin_selected(coin_value: float) -> void:
	emit_signal("coin_selected", coin_value);

func get_coins() -> Array[float]:
	return coins;

func open_drawer() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d, "position", Vector2(starting_x - 180*coins.size(), 0), 1.0);
	
func close_drawer() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d, "position", Vector2(starting_x, 0), 1.0);
