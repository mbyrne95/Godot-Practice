extends Line2D

var queue : Array
@export var max_length = 40

func _ready():
	pass
	#global_position = get_parent().global_position
	#set_point_position(0, global_position)

func _process(_delta):
	global_position = Vector2.ZERO
	global_rotation = 0
	#global_position = $"..".global_position

	var pos = get_parent().global_position
	print(pos)
	
	queue.push_front(pos)
	
	if queue.size() > max_length:
		queue.pop_back()
		
	clear_points()
	
	for point in queue:
		add_point(point)
