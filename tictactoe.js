function TicTacToe() {

	this.board = new Array();

	for (var i = 0; i < 3; i++) {
		this.board[i] = new Array();
		for (var j = 0; j < 3; j++) {
			this.board[i][j] = '-';
		}
	}

};

TicTacToe.prototype.get_board = function() {
	return this.board;
};

TicTacToe.prototype.make_player_move = function(i,j) {
	this.board[i][j] = 'x';
};

TicTacToe.prototype.make_ai_move = function() {
	var best_move = alpha_beta(this);
	this.board[best_move[0]][best_move[1]] = 'o';
};

TicTacToe.prototype.get_moves = function(player) {

	var moves = new Array();

	for (var i = 0; i < 3; i++) {
		for (var j = 0; j < 3; j++) {
			if(this.board[i][j] == '-') {
				moves.push([i,j]);
			}
		}
	}

	return moves;

};

TicTacToe.prototype.is_terminal = function() {
	var no_spaces = true;
	for (var i = 0; i < 3; i++) {
		for (var j = 0; j < 3; j++) {
			if(this.board[i][j] == '-') {
				no_spaces = false;
			}
		}
	}

	return no_spaces || this.get_score() != 0;
};

TicTacToe.prototype.get_score = function() {
	var lines = new Array(), board = this.board;
	lines.push(board[0]);
	lines.push(board[1]);
	lines.push(board[2]);
	lines.push([board[0][0],board[0][1],board[0][2]]);
	lines.push([board[1][0],board[1][1],board[1][2]]);
	lines.push([board[2][0],board[2][1],board[2][2]]);
	lines.push([board[0][0],board[1][1],board[2][2]]);
	lines.push([board[2][0],board[1][1],board[0][2]]);

	for (var i = 0; i < lines.length; i++) {
		if (lines[i][0] == lines[i][1] &&
			lines[i][1] == lines[i][2] &&
			lines[i][0] == 'x') {
			return 1;
		}
		if (lines[i][0] == lines[i][1] &&
			lines[i][1] == lines[i][2] &&
			lines[i][0] == 'o') {
			return -1;
		}
	}

	return 0;
};

TicTacToe.prototype.get_next = function(move,player) {
	if (player == "max") {
		player = 'x';
	} else {
		player = 'o';
	}

	var next_state = new TicTacToe();
	next_state.board = copy_board(this.board);
	next_state.board[move[0]][move[1]] = player;

	return next_state;
};

function alpha_beta(state) {

	return min_value(state,-100000,100000,true);

};

function max_value(state,alpha,beta,is_first) {

	var is_first = is_first || false;

	if (state.is_terminal()) {
		return state.get_score();
	}

	var v = -100000, moves = state.get_moves("max"), min, best_move = moves[0];

	for (var i = 0; i < moves.length; i++) {
		min = min_value(state.get_next(moves[i],"max"),alpha,beta,false);
		if (min > v) v = min, best_move = moves[i];
		if (v >= beta) {
			if (is_first) return moves[i];
			return v;
		}
		if (v > alpha) alpha = v;
	}

	if (is_first) {
		return best_move;
	} else {
		return v;
	}

};

function min_value(state,alpha,beta,is_first) {

	var is_first = is_first || false;

	if (state.is_terminal()) {
		return state.get_score();
	}

	var v = 100000, moves = state.get_moves("min"), max, best_move = moves[0];

	for (var i = 0; i < moves.length; i++) {
		max = max_value(state.get_next(moves[i],"min"),alpha,beta,false);
		if (max < v) v = max, best_move = moves[i];
		if (v <= alpha) {
			if (is_first) return moves[i];
			return v;
		}
		if (v < beta) beta = v;
	}

	if (is_first) {
		return best_move;
	} else {
		return v;
	}

};

function copy_board(board) {
	var new_board = Array();
	for (var i = 0; i < board.length; i++) {
		new_board[i] = board[i].slice(0);
	}
	return new_board;
};