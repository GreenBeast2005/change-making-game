extends Node2D

@onready var rich_text_label: RichTextLabel = $Hand/RichTextLabel
@onready var button: Button = $Hand/Button
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var customer_money: float;

func _ready() -> void:
	setup(customer_money);
	
func setup(money: float) -> void:
	customer_money = money;
	button.text = "$%.2f" % customer_money;
	button.pressed.connect(_on_button_pressed);
	play_animation("enter");
	button.visible = true;

func change_given() -> void:
	play_animation("exit");

signal accepted_customer_money(money: float);

func play_animation(animation: String) -> void:
	animation_player.play(animation);

func _on_button_pressed() -> void:
	emit_signal("accepted_customer_money", customer_money);
	play_animation("lower_hand");
	button.visible = false;

signal exited;

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "enter"):
		play_animation("raise_hand");
	if(anim_name == "raise_hand" || anim_name == "lower_hand"):
		play_animation("idle");
	if(anim_name == "exit"):
		emit_signal("exited");
