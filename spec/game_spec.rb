# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'

describe Game do
  subject(:game) { described_class.new(board, human_player, computer_player) }

  let(:board) { Board.new }
  let(:human_player) { instance_double(HumanPlayer) }
  let(:computer_player) { instance_double(ComputerPlayer) }

  let(:red) { :red }
  let(:yellow) { :yellow }

  describe '#over?' do
    context 'when no red disc is on the bounds of the board' do
      let(:yellow_picks) { [*0..6, 0, 6] }

      before do
        yellow_picks.each { |yellow_pick| game.board.drop_disc(yellow_pick, yellow) }
      end

      context 'for horizonal' do
        let(:red_picks) { [1, 2, 4] }

        before { red_picks.each { |red_pick| game.board.drop_disc(red_pick, red) } }

        context 'when 4 red discs are connected' do
          let(:winning_pick) { 3 }
  
          it 'is over' do
            color, col, row = game.board.drop_disc(winning_pick, red)
            expect(game.over?(color, col, row)).to be true
          end
        end
  
        context 'when 4 red discs are NOT connected' do
          let(:not_winning_pick) { 5 }
  
          it 'is not over' do
            color, col, row = game.board.drop_disc(not_winning_pick, red)
            expect(game.over?(color, col, row)).to be false
          end
        end
      end

      context 'for vertical' do
        let(:red_picks) { [5] * 3 }

        before { red_picks.each { |red_pick| game.board.drop_disc(red_pick, red) } }

        context 'when 4 red discs are connected' do
          let(:winning_pick) { 5 }
  
          it 'is over' do
            color, col, row = game.board.drop_disc(winning_pick, red)
            expect(game.over?(color, col, row)).to be true
          end
        end
  
        context 'when 4 red discs are NOT connected' do
          let(:not_winning_pick) { 5 }
  
          before do
            game.board.drop_disc(red_picks.first, yellow)
          end
  
          it 'is not over' do
            color, col, row = game.board.drop_disc(not_winning_pick, red)
            expect(game.over?(color, col, row)).to be false
          end
        end
      end

      context 'for diagonal' do
        context 'for forward-diagonal' do
          before do
            (1..3).each { |i| i.times { game.board.drop_disc(i + 1, yellow) } }
            red_picks.each { |red_pick| game.board.drop_disc(red_pick, red) }
          end

          context 'when 4 red discs are connected' do
            let(:red_picks) { [1, 2, 4] }
            let(:winning_pick) { 3 }
    
            it 'is over' do
              color, col, row = game.board.drop_disc(winning_pick, red)
              expect(game.over?(color, col, row)).to be true
            end
          end

          context 'when 4 red discs are NOT connected' do
            let(:red_picks) { [1, 2] }
            let(:not_winning_pick) { 4 }

            it 'is not over' do
              color, col, row = game.board.drop_disc(not_winning_pick, red)
              expect(game.over?(color, col, row)).to be false
            end
          end
        end

        context 'for backward-diagonal' do
          before do
            (1..3).each { |i| (4 - i).times { game.board.drop_disc(i, yellow) } }
            red_picks.each { |red_pick| game.board.drop_disc(red_pick, red) }
          end

          context 'when 4 red discs are connected' do
            let(:red_picks) { [1, 2, 4] }
            let(:winning_pick) { 3 }
    
            it 'is over' do
              color, col, row = game.board.drop_disc(winning_pick, red)
              expect(game.over?(color, col, row)).to be true
            end
          end

          context 'when 4 red discs are NOT connected' do
            let(:red_picks) { [1, 2] }
            let(:not_winning_pick) { 4 }

            it 'is not over' do
              color, col, row = game.board.drop_disc(not_winning_pick, red)
              expect(game.over?(color, col, row)).to be false
            end
          end
        end
      end
    end

    context 'when there are no 4 tokens of the same color' do
      context 'if the board is filled' do
        let(:draw_pick) { 5 }

        before do
          7.times do |i| 
            6.times do |j|
              next if i == draw_pick and j == 5
              game.board.drop_disc(i, i.even? ? red : yellow)
            end
          end
        end

        it do
          color, col, row = game.board.drop_disc(draw_pick, yellow)
          expect(game.over?(color, col, row)).to be true
        end
      end

      context 'if the board is not filled' do
        before do
          allow(game.board).to receive(:filled?).and_return(false)
        end

        it { expect(game.over?(yellow, 0, 0)).to be false }
      end
    end
  end
end
