extends Node2D

var piece_list = []
var texture_list = [GV.texture_0, GV.texture_1]
var divide_vec_list = [Vector2(8, 8), Vector2(12, 12)]
var circle_radius_list = [10, 7]

func _ready():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("KEY_SPACE"):
		$ShuffleButton.hide()
	if Input.is_action_just_released("KEY_SPACE"):
		$ShuffleButton.show()

func _on_shuffle_button_pressed():
	piece_list.clear()

	for piece in $Pieces.get_children():
		piece.queue_free()

	var dice = randi_range(0, 1)
	var dice2 = randi_range(0, 1)
	_set_up(texture_list[dice], divide_vec_list[dice2], circle_radius_list[dice2])

func _rand_pos(piece_size: Vector2) -> Vector2:
	var pos: = Vector2(500, 300)

	while (pos.x < 1000 - 150 and pos.x > 100 and pos.y < 600 - 100 and pos.y > 50) \
	or (pos.x > 1000 - piece_size.x or pos.y > 600 - piece_size.y) \
	or (pos.x > 1000 - 80 - piece_size.x and pos.y < 80):
		pos.x = randf_range(0, 1000)
		pos.y = randf_range(0, 600)
	
	return pos

func _set_up(texture: Texture2D, divide_vec: Vector2, circle_radius: float) -> void:
	for i in divide_vec.y:
		piece_list.append([])

	for i in divide_vec.y:
		for j in divide_vec.x:
			var piece = GV.scene_piece.instantiate();

			var piece_size = Vector2(piece.texture_size.x / divide_vec.x, piece.texture_size.y / divide_vec.y)
			var piece_offset = Vector2(piece_size.x * j, piece_size.y * i)
			piece.texture = texture
			piece.grid_size = divide_vec
			piece.index = Vector2(j, i)
			piece.piece_size = piece_size
			piece.piece_offset = piece_offset
			piece.circle_radius = circle_radius
			piece.position = _rand_pos(piece_size)
			piece.size = piece_size
			piece_list[i].append(piece)

			if j == 0 and i == 0:
				piece.up_type = PieceConsts.TYPE_ROUND_TOP_LEFT
				piece.left_type = PieceConsts.TYPE_ROUND_TOP_LEFT
				piece.down_type = PieceConsts.rand_in_out()
				piece.right_type = PieceConsts.rand_in_out()
				continue

			if j - 1 >= 0:
				var other_piece = piece_list[i][j - 1]
				piece.left_piece = other_piece
				other_piece.right_piece = piece
			if i - 1 >= 0:
				var other_piece = piece_list[i - 1][j]
				piece.up_piece = other_piece
				other_piece.down_piece = piece

			if j == divide_vec.x - 1 and i == 0:
				piece.up_type = PieceConsts.TYPE_ROUND_TOP_RIGHT
				piece.right_type = PieceConsts.TYPE_ROUND_TOP_RIGHT
				continue

			if j == divide_vec.x - 1 and i == divide_vec.y - 1:
				piece.down_type = PieceConsts.TYPE_ROUND_BOTTOM_RIGHT
				piece.right_type = PieceConsts.TYPE_ROUND_BOTTOM_RIGHT
				continue

			if j == 0 and i == divide_vec.y - 1:
				piece.down_type = PieceConsts.TYPE_ROUND_BOTTOM_LEFT
				piece.left_type = PieceConsts.TYPE_ROUND_BOTTOM_LEFT
				continue

			if j == 0:
				piece.left_type = PieceConsts.TYPE_FLAT
				continue

			if j == divide_vec.x - 1:
				piece.right_type = PieceConsts.TYPE_FLAT
				continue

			if i == 0:
				piece.up_type = PieceConsts.TYPE_FLAT
				continue

			if i == divide_vec.y - 1:
				piece.down_type = PieceConsts.TYPE_FLAT
				continue

	for i in divide_vec.y:
		for j in divide_vec.x:
			var piece = piece_list[i][j]
			if piece.left_piece != null:
				var other_piece = piece_list[i][j - 1]
				piece.left_type = PieceConsts.reverse(other_piece.right_type)
			if piece.up_piece != null:
				var other_piece = piece_list[i - 1][j]
				piece.up_type = PieceConsts.reverse(other_piece.down_type)
			if piece.right_piece != null:
				piece.right_type = PieceConsts.rand_in_out()
			if piece.down_piece != null:
				piece.down_type = PieceConsts.rand_in_out()

	for i in divide_vec.y:
		for j in divide_vec.x:
			$Pieces.add_child(piece_list[i][j])
