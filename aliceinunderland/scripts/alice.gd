extends CharacterBody2D

var isMoving : bool = false
var tileSize = 32
@onready var animation = $AnimatedSprite2D
@onready var ray = $RayCast2D
@onready var sound = $AudioStreamPlayer2D

func _physics_process(delta: float) -> void:
	move()

func move():
	var dir = Vector2(Input.get_axis("move_left", "move_right"),0 if Input.get_axis("move_left", "move_right") else Input.get_axis("move_up", "move_down"))
	if !isMoving:
		if dir:
			animation.play(("WalkLeft" if dir.x == -1 else "WalkRight") if dir.x else ("WalkUp" if dir.y == -1 else "WalkDown"))
			animation.set_speed_scale(testSprint(1.67,1))
			ray.target_position = dir * tileSize
			ray.force_raycast_update()
			sound.play()
			if !ray.is_colliding():
				isMoving = true;
				var tween = create_tween()
				tween.tween_property(self, "position", position + (dir * tileSize), testSprint(0.17,0.3))
				tween.tween_callback(func callback(): isMoving = false)
			reposByTile(-1,3,dir,Vector2(0,1),-1,15)
			reposByTile(-1,15,dir,Vector2(0,-1),-1,3)
			reposByTile(5,2,dir,Vector2(1,0),18,2)
			reposByTile(18,2,dir,Vector2(-1,0),5,2)
			reposByTile(5,3,dir,Vector2(1,0),18,3)
			reposByTile(18,3,dir,Vector2(-1,0),5,3)
			reposByTile(25,-2,dir,Vector2(0,-1),25,-12)
			reposByTile(25,-12,dir,Vector2(0,1),25,-2)
		else:
			animation.stop()
			animation.set_frame_and_progress(1,0.99)

func testSprint(v1,v2):
	return v1 if Input.is_action_pressed("sprint",true) else v2

func reposition(x1,y1,idir,dir,x2,y2):
	if(position == Vector2(x1,y1) && idir == dir):
		position = Vector2(x2,y2)

func reposByTile(x1,y1,idir,dir,x2,y2):
	reposition((x1 * 32) + 16,(y1 * 32) + 16,idir,dir,(x2 * 32) + 16,(y2 * 32) + 16)
