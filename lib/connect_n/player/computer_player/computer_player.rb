# frozen_string_literal: true

require_relative '../player'
require_relative '../../winnable/winnable'

module ConnectN
  class ComputerPlayer < Player
    include Winnable

    attr_accessor :difficulty, :delay
    attr_reader :opponent_disc, :min_to_win

    def initialize(
      name: 'Computer',
      disc: '🧊',
      min_to_win: 4,
      difficulty: 0,
      delay: 0,
      board:,
      opponent_disc:
    )
      super(name: name, disc: disc)
      @min_to_win = min_to_win
      @difficulty = difficulty
      @delay = delay
      @board = board
      @opponent_disc = opponent_disc
      @scores = { disc => 10000, opponent_disc => -10000 }
    end

    def pick
      sleep delay
      best_score = -Float::INFINITY
      best_pick = nil
      @board.cols_amount.times do |pick|
        next unless @board.valid_pick?(pick)

        board_copy = @board.clone
        row_num, col_num = board_copy.drop_disc(disc, at_col: pick)
        score = minimax(board_copy, disc, row_num, col_num)
        if score >= best_score
          best_score = score
          best_pick = pick
        end
      end
      best_pick
    end

    private

    attr_reader :scores

    def minimax(
      current_board,
      current_disc,
      row_num,
      col_num,
      moves_counter = 0,
      alpha = -Float::INFINITY,
      beta = Float::INFINITY,
      depth = difficulty,
      maximizing: false
    )
      return calculate_win_score(current_disc, moves_counter) if win?(current_board, row_num, col_num, current_disc)

      return 0 if current_board.filled?

      return heuristic(current_board, current_disc) if depth <= 0

      if maximizing
        score = -Float::INFINITY
        @board.cols_amount.times do |pick|
          next unless current_board.valid_pick?(pick)

          board_copy = current_board.clone
          row_num, col_num = board_copy.drop_disc(disc, at_col: pick)
          score = [
            score,
            minimax(board_copy, disc, row_num, col_num, moves_counter + 1, alpha, beta, depth - 1, maximizing: false)
          ].max
          break if score >= beta

          alpha = [alpha, score].max
        end
      else
        score = Float::INFINITY
        @board.cols_amount.times do |pick|
          next unless current_board.valid_pick?(pick)

          board_copy = current_board.clone
          row_num, col_num = board_copy.drop_disc(opponent_disc, at_col: pick)
          score = [
            score,
            minimax(board_copy, opponent_disc, row_num, col_num, moves_counter + 1, alpha, beta, depth - 1, maximizing: true)
          ].min
          break if score <= alpha

          beta = [beta, score].min
        end
      end
      score
    end

    def calculate_win_score(disc, moves_counter)
      score = scores[disc] * @board.cols_amount * @board.rows_amount
      score / moves_counter.to_f
    end

    def heuristic(board, disc)
      value = 0
      board.rows.each do |row|
        row.each_cons(min_to_win).each do |set_of_n|
          disc_count = set_of_n.count disc
          opponent_disc_count = set_of_n.count opponent_disc
          next if [disc_count, opponent_disc_count].none?(&:zero?)

          value += disc_count
          value -= opponent_disc_count
        end
      end
      value
    end
  end
end
