extends Node2D

signal register_opened(status: bool);

@export var price_due: float;
var customer_paid: bool = false;

var drawer_opened: bool = false;

@onready var rich_text_label: RichTextLabel = $Sprite2D/RichTextLabel
@onready var sprite_2d: Sprite2D = $Sprite2D;

func _ready() -> void:
	set_price(price_due);

func reset() -> void:
	customer_paid = false;
	set_price(0.00);

## Use this in manager to show how much is due.
func set_price(price: float) -> void:
	price_due = price;
	rich_text_label.text = "$%.2f" % price_due;

func accept_payment(money: float) -> void:
	price_due = price_due - money;
	rich_text_label.text = "$%.2f" % price_due;
	customer_paid = true;

signal gave_sufficient_change(overshot: float);

func give_change(change: float) -> bool:
	if customer_paid:
		price_due += change;
		rich_text_label.text = "$%.2f" % price_due;
		if price_due > 0:
			emit_signal("gave_sufficient_change", price_due);
			return true;
		if price_due >= -0.009:
			set_price(0);
			emit_signal("gave_sufficient_change", 0);
			return true;
		return true;
	return false;

func _on_button_mouse_entered() -> void:
	sprite_2d.frame = 1;

func _on_button_mouse_exited() -> void:
	sprite_2d.frame = 0;


func _on_button_pressed() -> void:
	drawer_opened = !drawer_opened;
	emit_signal("register_opened", drawer_opened);
