extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rich_text_label: RichTextLabel = $RichTextLabel

@export var minX: int = 0;
@export var maxX: int = 1920;

@export var minY: int = 0;
@export var maxY: int = 1080;

@export var minAngle: int = -15;
@export var maxAngle: int = 15;

func show_popup(message: String):
	position = Vector2(minX + (randi() % (maxX - minX)), minY + (randi() % (maxY - minY)));
	print(position);
	rotation_degrees = randf_range(minAngle, maxAngle);
	rich_text_label.text = message;
	animation_player.play("grow_and_shrink");
