extends HBoxContainer

func _setup_buttons(coins: Array[float]):
	for i in coins.size():
		var btn = Button.new();
		btn.custom_minimum_size = Vector2(180, 256)  # Width x Height
		btn.text = "$%.2f" % coins[i];
		
		# Connect button press and bind the coin value
		btn.pressed.connect(_on_button_pressed.bind(coins[i]))
		
		add_child(btn);

signal coin_selected(coin_value: float)

func _on_button_pressed(coin_value: float) -> void:
	emit_signal("coin_selected", coin_value)
