extends aoe_dmg

func _ready():
	damage = 20
	timescale = 1.5
	
	player = get_tree().get_first_node_in_group("players")
	inner = $CanvasLayer/ColorRect
	outer = $CanvasLayer/ColorRect2
	#ring_scale = scale 
	outer_color = Vector4(1,0,0,1)
	outer.material.set_shader_parameter("Color",outer_color)
	outer.position = global_position - Vector2(160,160)
	outer.scale = scale
	
	anim_player = $AnimationPlayer
	lifespan = $lifespan
	
	inner_color = Vector4(0.9,0.7,0.9,1)
	inner.material.set_shader_parameter("Color",inner_color)
	inner.position = global_position - Vector2(160,160)
	inner.scale = scale
	
	anim_player.speed_scale = timescale
	
