# frozen_string_literal: true

require_relative '../player'
require_relative '../../winnable/winnable'

module ConnectFour
  class ComputerPlayer < Player
    include Winnable
  
    attr_reader :opponent_color
    attr_accessor :difficulty, :delay
  
    def initialize(board, name: 'Computer', color: :yellow, opponent_color: :red, difficulty: 0, delay: 1)
      super(name: name, color: color)
      @board = board
      @opponent_color = opponent_color
      @difficulty = difficulty
      @delay = delay
      @scores = { color => Float::INFINITY, opponent_color => -Float::INFINITY }
    end
  
    def pick
      sleep delay
      best_score = -Float::INFINITY
      alpha = best_score
      beta = -best_score
      best_pick = nil
      7.times do |pick|
        next unless @board.valid_pick?(pick)
  
        board_copy = @board.dup
        _, col, row = board_copy.drop_disc(pick, color)
        score = minimax(board_copy, color, col, row, alpha, beta)
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
  
    def minimax(current_board, current_color, col, row, alpha, beta, depth = difficulty, maximizing: false)
      return scores[current_color] if win?(current_board, current_color, col, row)
  
      return 0 if current_board.filled?
  
      return heuristic(current_board) if depth.negative?
  
      if maximizing
        score = -Float::INFINITY
        7.times do |pick|
          next unless current_board.valid_pick?(pick)
  
          board_copy = current_board.dup
          _, col, row = board_copy.drop_disc(pick, color)
          score = [
            score,
            minimax(board_copy, color, col, row, alpha, beta, depth - 1, maximizing: false)
          ].max
          break if score >= beta
          alpha = [alpha, score].max
        end
      else
        score = Float::INFINITY
        7.times do |pick|
          next unless current_board.valid_pick?(pick)
  
          board_copy = current_board.dup
          _, col, row = board_copy.drop_disc(pick, opponent_color)
          score = [
            score,
            minimax(board_copy, opponent_color, col, row, alpha, beta, depth - 1, maximizing: true)
          ].min
          break if score <= alpha
          beta = [beta, score].min
        end
      end
      score
    end
  
    def heuristic(current_board)
      rows = current_board.cols.transpose
      value = 0
      opponent_value = 0
      rows.each do |row|
        row.each_cons(4).each do |set_of_four|
          color_count = set_of_four.count color
          opponent_color_count = set_of_four.count opponent_color
          next if [color_count, opponent_color_count].none?(&:zero?)
  
          value += color_count
          opponent_value += opponent_color_count
        end
      end
      value - opponent_value
    end
  end  
end
