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

  describe "#over?" do
    context 'when a player has won' do
      before { allow(game).to receive(:win?).and_return(true) }
      
      it { expect(game).to receive(:win?) }
      
      it { expect(board).not_to receive(:filled?) }

      it { expect(game.over?).to be true }
    end

    context 'when a player has not won' do
      before { allow(game).to receive(:win?).and_return(false) }

      context 'when the board is filled' do
        before { allow(board).to receive(:filled?).and_return(true) }
          
        it { expect(game).to receive(:win?) }
        
        it { expect(board).to receive(:filled?) }

        it { expect(game.over?).to be true }
        end
      end

      context 'when the board is not filled' do
        before { allow(board).to receive(:filled?).and_return(false) }

        it { expect(game).to receive(:win?) }

        it { expect(board).to receive(:filled?) }

        it { expect(game.over?).to be false }
      end
    end
  end

  describe '#win?' do
    context 'when no red disc is on the bounds of the board' do
      let(:yellow_picks) { [*0..6, 0, 6] }

      before do
        yellow_picks.each { |yellow_pick| board.drop_disc(yellow_pick, yellow) }
      end

      context 'for horizonal' do
        before { red_picks.each { |red_pick| board.drop_disc(red_pick, red) } }

        context 'when 4 red discs are connected' do
          let(:red_picks) { [1, 2, 4] }
          let(:winning_pick) { 3 }
  
          it 'returns true' do
            color, col, row = board.drop_disc(winning_pick, red)
            expect(game.win?(color, col, row)).to be true
          end
        end
  
        context 'when only 3 red discs are connected' do
          let(:red_picks) { [1, 2] }
          let(:not_winning_red_pick) { 3 }
  
          it do
            color, col, row = board.drop_disc(not_winning_red_pick, red)
            expect(game.win?(color, col, row)).to be false
          end
        end

        context 'when only 2 red discs are connected' do
          let(:red_picks) { [1] }
          let(:not_winning_red_pick) { 2 }
  
          it do
            color, col, row = board.drop_disc(not_winning_red_pick, red)
            expect(game.win?(color, col, row)).to be false
          end
        end

        context 'when there is only 1 red disc' do
          let(:red_picks) { [] }
          let(:not_winning_red_pick) { 1 }
  
          it do
            color, col, row = board.drop_disc(not_winning_red_pick, red)
            expect(game.win?(color, col, row)).to be false
          end
        end
      end

      context 'for vertical' do
        before { red_picks.each { |red_pick| board.drop_disc(red_pick, red) } }

        context 'when 4 red discs are connected' do
          let(:red_picks) { [5] * 3 }
          let(:winning_pick) { 5 }
  
          it do
            color, col, row = board.drop_disc(winning_pick, red)
            expect(game.win?(color, col, row)).to be true
          end
        end
  
        context 'when only 3 red discs are connected' do  
          let(:red_picks) { [5] * 2 }
          let(:not_winning_red_pick) { 5 }

          it do
            color, col, row = board.drop_disc(not_winning_red_pick, red)
            expect(game.win?(color, col, row)).to be false
          end
        end

        context 'when only 2 red discs are connected' do  
          let(:red_picks) { [5] }
          let(:not_winning_red_pick) { 5 }

          it do
            color, col, row = board.drop_disc(not_winning_red_pick, red)
            expect(game.win?(color, col, row)).to be false
          end
        end

        context 'when there is only 1 red disc' do  
          let(:red_picks) { [] }
          let(:not_winning_red_pick) { 5 }

          it do
            color, col, row = board.drop_disc(not_winning_red_pick, red)
            expect(game.win?(color, col, row)).to be false
          end
        end
      end

      context 'for diagonal' do
        context 'for forward-diagonal' do
          before do
            (1..3).each { |i| i.times { board.drop_disc(i + 1, yellow) } }
            red_picks.each { |red_pick| board.drop_disc(red_pick, red) }
          end

          context 'when 4 red discs are connected' do
            let(:red_picks) { [1, 2, 4] }
            let(:winning_pick) { 3 }
    
            it do
              color, col, row = board.drop_disc(winning_pick, red)
              expect(game.win?(color, col, row)).to be true
            end
          end

          context 'when only 3 red discs are connected' do
            let(:red_picks) { [1, 2] }
            let(:not_winning_red_pick) { 3 }

            it do
              color, col, row = board.drop_disc(not_winning_red_pick, red)
              expect(game.win?(color, col, row)).to be false
            end
          end

          context 'when only 2 red discs are connected' do
            let(:red_picks) { [1] }
            let(:not_winning_red_pick) { 2 }

            it do
              color, col, row = board.drop_disc(not_winning_red_pick, red)
              expect(game.win?(color, col, row)).to be false
            end
          end

          context 'when there is only 1 red disc' do
            let(:red_picks) { [] }
            let(:not_winning_red_pick) { 1 }

            it do
              color, col, row = board.drop_disc(not_winning_red_pick, red)
              expect(game.win?(color, col, row)).to be false
            end
          end
        end

        context 'for backward-diagonal' do
          before do
            (1..3).each { |i| (4 - i).times { board.drop_disc(i, yellow) } }
            red_picks.each { |red_pick| board.drop_disc(red_pick, red) }
          end

          context 'when 4 red discs are connected' do
            let(:red_picks) { [1, 2, 4] }
            let(:winning_pick) { 3 }
    
            it do
              color, col, row = board.drop_disc(winning_pick, red)
              expect(game.win?(color, col, row)).to be true
            end
          end

          context 'when only 3 red discs are connected' do
            let(:red_picks) { [1, 2] }
            let(:not_winning_red_pick) { 3 }

            it do
              color, col, row = board.drop_disc(not_winning_red_pick, red)
              expect(game.win?(color, col, row)).to be false
            end
          end

          context 'when only 2 red discs are connected' do
            let(:red_picks) { [1] }
            let(:not_winning_red_pick) { 2 }

            it do
              color, col, row = board.drop_disc(not_winning_red_pick, red)
              expect(game.win?(color, col, row)).to be false
            end
          end

          context 'when there is only 1 red disc' do
            let(:red_picks) { [] }
            let(:not_winning_red_pick) { 1 }

            it do
              color, col, row = board.drop_disc(not_winning_red_pick, red)
              expect(game.win?(color, col, row)).to be false
            end
          end
        end
      end
    end
  end
end
