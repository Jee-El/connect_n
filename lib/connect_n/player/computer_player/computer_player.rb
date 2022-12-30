# frozen_string_literal: true

require_relative '../player'
require_relative '../../winnable/winnable'

module ConnectN
  class ComputerPlayer < Player
    include Winnable

    attr_accessor :opponent_disc, :difficulty, :delay, :min_to_win

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
      @scores = { disc => Float::INFINITY, opponent_disc => -Float::INFINITY }
    end

    def pick
      sleep delay
      best_score = -Float::INFINITY
      alpha = best_score
      beta = -best_score
      best_pick = nil
      @board.cols_amount.times do |pick|
        next unless @board.valid_pick?(pick)

        board_copy = @board.clone
        i, j = board_copy.drop_disc(disc, at_col: pick)
        score = minimax(board_copy, disc, i, j, alpha, beta)
        if score > best_score
          best_score = score
          best_pick = pick
        end
        break if best_score >= beta

        alpha = [alpha, best_score].max
      end
      best_pick
    end

    private

    attr_reader :scores

    def minimax(current_board, current_disc, i, j, alpha, beta, depth = difficulty, maximizing: false)
      return scores[current_disc] if win?(current_board, i, j, current_disc)

      return 0 if current_board.filled?

      return heuristic(current_board) if depth.negative?

      if maximizing
        score = -Float::INFINITY
        @board.cols_amount.times do |pick|
          next unless current_board.valid_pick?(pick)

          board_copy = current_board.dup
          i, j = board_copy.drop_disc(disc, at_col: pick)
          score = [
            score,
            minimax(board_copy, disc, i, j, alpha, beta, depth - 1, maximizing: false)
          ].max
          break if score >= beta

          alpha = [alpha, score].max
        end
      else
        score = Float::INFINITY
        @board.cols_amount.times do |pick|
          next unless current_board.valid_pick?(pick)

          board_copy = current_board.dup
          i, j = board_copy.drop_disc(opponent_disc, at_col: pick)
          score = [
            score,
            minimax(board_copy, opponent_disc, i, j, alpha, beta, depth - 1, maximizing: true)
          ].min
          break if score <= alpha

          beta = [beta, score].min
        end
      end
      score
    end

    def heuristic(current_board)
      value = 0
      opponent_value = 0
      current_board.table.each do |row|
        row.each_cons(min_to_win).each do |set_of_n|
          disc_count = set_of_n.count disc
          opponent_disc_count = set_of_n.count opponent_disc
          next if [disc_count, opponent_disc_count].none?(&:zero?)

          value += disc_count
          opponent_value += opponent_disc_count
        end
      end
      value - opponent_value
    end
  end
end
