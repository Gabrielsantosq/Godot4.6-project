extends HBoxContainer

@onready var heart_gui = preload("res://scenes/heart_gui.tscn")
func _ready() -> void:
	pass 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setMaxHearts(max: int):
	for i in range(max):
		var heart = heart_gui.instantiate()
		add_child(heart)
		
func updateHearts(current_health):
	pass
