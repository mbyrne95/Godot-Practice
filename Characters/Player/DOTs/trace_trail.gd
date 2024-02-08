extends Line2D

var queue : Array
@export var max_length = 40

func _ready():
	global_position = $"..".global_position
	#global_position = get_parent().global_position
	#set_point_position(0, global_position)

func _process(_delta):
	global_position = $"..".global_position

	var pos = global_position
	print(pos)
	
	queue.push_front(pos)
	
	if queue.size() > max_length:
		queue.pop_back()
		
	clear_points()
	
	for point in queue:
		add_point(point)
