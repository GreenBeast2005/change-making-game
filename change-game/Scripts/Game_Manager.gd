extends Node2D

@onready var change_drawer: Node2D = $StuffThatMoves/Change_Drawer
@onready var register: Node2D = $StuffThatMoves/Register
@onready var customer: Node2D = $StuffThatMoves/Customer
@onready var stuff_that_moves: Node2D = $StuffThatMoves
@onready var score: RichTextLabel = $Score
@onready var text_popup: Node2D = $StuffThatMoves/TextPopup

var customers_served: int = 0;
var points: int = 0;

@export var max_change: float = 5.0;
@export var customers_til_shop: int = 5;

@export var customers_til_next_level: int = 25;

func _ready() -> void:
	randomize();
	score.text = "Points: %d" % points;
	register.reset();
	coins_used = 0;
	next_customer();

func round_to_places(value: float, places: int) -> float:
	var factor = pow(10, places)
	return round(value * factor) / factor
	
func add_points(value: int):
	points = points + value;
	score.text = "Points: %d" % points;

func next_customer() -> void:
	var change_needed = randf_range(0, max_change);
	change_needed = round_to_places(change_needed, 2);
	var money_due = randf_range(2, max_change * 10);
	money_due = round_to_places(money_due, 2);
	register.set_price(money_due);
	customer.setup(money_due + change_needed);
	perfect_coins = min_coins_float(change_drawer.get_coins(), change_needed);
	print(perfect_coins);

var coins_used: int = 0;
var perfect_coins: int = 0;
func _on_change_drawer_coin_selected(coin_value: float) -> void:
	if(register.give_change(coin_value)):
		coins_used = coins_used + 1;
	

func _on_register_register_opened(status: bool) -> void:
	if status:
		change_drawer.open_drawer();
	else:
		change_drawer.close_drawer();

func _on_customer_accepted_customer_money(money: float) -> void:
	register.accept_payment(money);

func _on_register_gave_sufficient_change(overshot: float) -> void:
	coins_used = coins_used + 1;
	customer.change_given();
	if(coins_used == perfect_coins):
			text_popup.show_popup("Used minimum coins!!");
	add_points(calculate_points() * (1.0 - overshot));
	increase_customers_served();

func calculate_points() -> int:
	return 500 * perfect_coins / coins_used;

func increase_customers_served() -> void:
	customers_served = customers_served + 1;
	#print(customers_served);
	if(customers_served % customers_til_shop == 0):
		move_to_shop();

func move_to_shop() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(stuff_that_moves, "position", Vector2(1920, 0), 1.0);

func _on_customer_exited() -> void:
	register.reset();
	coins_used = 0;
	next_customer();

func min_coins_float(coins: Array[float], total: float) -> int:
	var scale := 100  # Scale to work in cents
	var int_coins := coins.map(func(c): return int(round(c * scale)))
	var int_total := int(round(total * scale))
	
	var dp := []
	for i in int_total + 1:
		dp.append(999999)  # INF
	
	dp[0] = 0  # Base case
	
	for i in range(int_coins.size() - 1, -1, -1):
		for j in range(1, int_total + 1):
			var take = 999999
			var no_take = dp[j]
			
			if j - int_coins[i] >= 0 and int_coins[i] > 0:
				take = dp[j - int_coins[i]]
				if take != 999999:
					take += 1
			
			dp[j] = min(take, no_take)
	
	return dp[int_total] if dp[int_total] != 999999 else -1
