extends Node2D

var piece_list = []

func _ready():
	var divide_vec = Vector2(8, 8)

	for i in divide_vec.y:
		piece_list.append([])

	for i in divide_vec.y:
		for j in divide_vec.x:
			var piece = GV.scene_piece.instantiate();

			var piece_size = Vector2(piece.TextureSize.x / divide_vec.x, piece.TextureSize.y / divide_vec.y)
			var piece_offset = Vector2(piece_size.x * j, piece_size.y * i)
			piece.grid_size = divide_vec
			piece.index = Vector2(j, i)
			piece.piece_size = piece_size
			piece.piece_offset = piece_offset
			piece.position = piece_offset + Vector2(j * 20, i * 20)
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
