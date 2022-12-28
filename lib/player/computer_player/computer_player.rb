# frozen_string_literal: true

require_relative '../player'
require_relative '../../winnable/winnable'

module ConnectFour
  class ComputerPlayer < Player
    include Winnable

    attr_reader :opponent_disc
    attr_accessor :difficulty, :delay

    def initialize(board, name: 'Computer', disc: '🎁', opponent_disc: '🔥', difficulty: 0, delay: 0)
      super(name: name, disc: disc)
      @board = board
      @opponent_disc = opponent_disc
      @difficulty = difficulty
      @delay = delay
      @scores = { disc => Float::INFINITY, opponent_disc => -Float::INFINITY }
    end

    def pick
      sleep delay
      best_score = -Float::INFINITY
      alpha = best_score
      beta = -best_score
      best_pick = nil
      @board.table.columns_count.times do |pick|
        next unless @board.valid_pick?(pick)

        board_copy = @board.dup
        row, col = board_copy.drop_disc(disc, at_col: pick)
        score = minimax(board_copy, disc, row, col, alpha, beta)
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

    def minimax(current_board, current_disc, row, col, alpha, beta, depth = difficulty, maximizing: false)
      return scores[current_disc] if win?(current_board, row, col, current_disc)

      return 0 if current_board.filled?

      return heuristic(current_board) if depth.negative?

      if maximizing
        score = -Float::INFINITY
        @board.table.columns_count.times do |pick|
          next unless current_board.valid_pick?(pick)

          board_copy = current_board.dup
          row, col = board_copy.drop_disc(disc, at_col: pick)
          score = [
            score,
            minimax(board_copy, disc, row, col, alpha, beta, depth - 1, maximizing: false)
          ].max
          break if score >= beta

          alpha = [alpha, score].max
        end
      else
        score = Float::INFINITY
        @board.table.columns_count.times do |pick|
          next unless current_board.valid_pick?(pick)

          board_copy = current_board.dup
          row, col = board_copy.drop_disc(opponent_disc, at_col: pick)
          score = [
            score,
            minimax(board_copy, opponent_disc, row, col, alpha, beta, depth - 1, maximizing: true)
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
      current_board.table.rows.each do |row|
        row.each_cons(4).each do |set_of_four|
          disc_count = set_of_four.count disc
          opponent_disc_count = set_of_four.count opponent_disc
          next if [disc_count, opponent_disc_count].none?(&:zero?)

          value += disc_count
          opponent_value += opponent_disc_count
        end
      end
      value - opponent_value
    end
  end
end
