extends enemy_baseclass

var offset = 20

var x
var y
var has_direction = false
var walk_time = 2
var idle_time = 2

var start_pos
var dir = Vector2.RIGHT
var last_dir = dir
var timer
var timer_started = false
#var start_walking = false
var rotation_speed =  200

enum{
	IDLE,
	NEW_DIRECTION,
	MOVE
}

var current_state = IDLE
var last_state = current_state

func _ready():
	self.add_to_group("enemies")
	SHOOT_CD = 0.1
	timer = $Timer
	sprite = $Sprite2D
	muzzle = $Muzzle
	hit_flash_player = $HitFlashPlayer
	projectile_scene = preload("res://Characters/Enemies/Projectiles/round_enemy_bullet.tscn")
	Globs.children_allowed_to_move.connect(_connect_allowed_to_move)
	start_pos = position
	randomize()

func _process(delta):
	if allowed_to_move:
		look_at(player.position)
		if !timer_started:
			timer.start()
			timer_started = true
		match current_state:
			IDLE:
				shoot_logic()
				return
			NEW_DIRECTION:
				while dir == last_dir:
					dir = choose([Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN, Vector2(1,1),
					Vector2(-1,-1), Vector2(1,-1),Vector2(-1,1)])

				last_dir = dir
				current_state = MOVE
			MOVE:
				move(delta)

		
func move(delta):
	#var tween = create_tween
	#tween.tween_property(self, "position", position + (dir * SPEED), walk_time)
	position.x = clamp((position.x + (dir.x * (SPEED * 0.3) * delta)), 20, 160)
	position.y = clamp((position.y + (dir.y * (SPEED * 0.3) * delta)), 20, 300)
	#position += dir * SPEED * delta
	

func choose(array):
	array.shuffle()
	return array.front()

func idle_direction_pick():
	#allowed_to_move = false
	if player == null:
		return
	var time_in_state = randf_range(2,3)
	x = randf_range(-1,1)
	y = randf_range(-1,1)
	x = clamp(x*SPEED, 20, 160)
	y = clamp(y*SPEED, 20, 300)
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(x,y), 2).set_trans(Tween.TRANS_CUBIC)
	await get_tree().create_timer(time_in_state).timeout
	allowed_to_move = true
	
func _countdown():
	await get_tree().create_timer(walk_time).timeout
	allowed_to_move = false
	await get_tree().create_timer(idle_time).timeout
	allowed_to_move = true

func _on_timer_timeout():
	print(current_state)
	timer.wait_time = choose([0.4,0.5])
	while current_state == last_state:
		current_state = choose([IDLE,NEW_DIRECTION])
	last_state = current_state
