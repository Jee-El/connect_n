# frozen_string_literal: true

require_relative '../lib/game/game'
require_relative '../lib/board/board'

describe ConnectFour::Game do
  subject(:game) { described_class.new(board, human_player, computer_player) }

  let(:board) { ConnectFour::Board.new }
  let(:human_player) { instance_double(ConnectFour::HumanPlayer, disc: '🔥') }
  let(:computer_player) { instance_double(ConnectFour::ComputerPlayer, disc: '🎁') }

  let(:fire) { human_player.disc }
  let(:snowflake) { computer_player.disc }

  describe '#over?' do
    context 'when a player has won' do
      before { allow(game).to receive(:win?).and_return(true) }

      it do
        expect(game).to receive(:win?)
        game.over?(board)
      end

      it do
        expect(board).not_to receive(:filled?)
        game.over?(board)
      end

      it { expect(game.over?(board)).to be true }
    end

    context 'when a player has not won' do
      before { allow(game).to receive(:win?).and_return(false) }

      context 'when the board is filled' do
        before { allow(board).to receive(:filled?).and_return(true) }

        it do
          expect(game).to receive(:win?)
          game.over?(board)
        end

        it do
          expect(board).to receive(:filled?)
          game.over?(board)
        end

        it { expect(game.over?(board)).to be true }
      end

      context 'when the board is not filled' do
        before { allow(board).to receive(:filled?).and_return(false) }

        it do
          expect(game).to receive(:win?)
          game.over?(board)
        end

        it do
          expect(board).to receive(:filled?)
          game.over?(board)
        end

        it { expect(game.over?(board)).to be false }
      end
    end
  end

  describe '#win?' do
    context 'when no fire disc is on the first or last col of the board' do
      let(:yellow_picks) { [*0..6, 0, 6] }

      before do
        yellow_picks.each { |yellow_pick| board.drop_disc(yellow_pick, snowflake) }
      end

      context 'for horizonal' do
        before { red_picks.each { |red_pick| board.drop_disc(red_pick, fire) } }

        context 'when 4 fire discs are connected' do
          let(:red_picks) { [1, 2, 4] }
          let(:winning_pick) { 3 }

          it 'returns true' do
            color, col, row = board.drop_disc(winning_pick, fire)
            expect(game.win?(board, color, col, row)).to be true
          end
        end

        context 'when only 3 fire discs are connected' do
          let(:red_picks) { [1, 2] }
          let(:not_winning_red_pick) { 3 }

          it do
            color, col, row = board.drop_disc(not_winning_red_pick, fire)
            expect(game.win?(board, color, col, row)).to be false
          end
        end

        context 'when only 2 fire discs are connected' do
          let(:red_picks) { [1] }
          let(:not_winning_red_pick) { 2 }

          it do
            color, col, row = board.drop_disc(not_winning_red_pick, fire)
            expect(game.win?(board, color, col, row)).to be false
          end
        end

        context 'when there is only 1 fire disc' do
          let(:red_picks) { [] }
          let(:not_winning_red_pick) { 1 }

          it do
            color, col, row = board.drop_disc(not_winning_red_pick, fire)
            expect(game.win?(board, color, col, row)).to be false
          end
        end
      end

      context 'for vertical' do
        before { red_picks.each { |red_pick| board.drop_disc(red_pick, fire) } }

        context 'when 4 fire discs are connected' do
          let(:red_picks) { [5] * 3 }
          let(:winning_pick) { 5 }

          it do
            color, col, row = board.drop_disc(winning_pick, fire)
            expect(game.win?(board, color, col, row)).to be true
          end
        end

        context 'when only 3 fire discs are connected' do
          let(:red_picks) { [5] * 2 }
          let(:not_winning_red_pick) { 5 }

          it do
            color, col, row = board.drop_disc(not_winning_red_pick, fire)
            expect(game.win?(board, color, col, row)).to be false
          end
        end

        context 'when only 2 fire discs are connected' do
          let(:red_picks) { [5] }
          let(:not_winning_red_pick) { 5 }

          it do
            color, col, row = board.drop_disc(not_winning_red_pick, fire)
            expect(game.win?(board, color, col, row)).to be false
          end
        end

        context 'when there is only 1 fire disc' do
          let(:red_picks) { [] }
          let(:not_winning_red_pick) { 5 }

          it do
            color, col, row = board.drop_disc(not_winning_red_pick, fire)
            expect(game.win?(board, color, col, row)).to be false
          end
        end
      end

      context 'for diagonal' do
        context 'for forward-diagonal' do
          before do
            (1..3).each { |i| i.times { board.drop_disc(i + 1, snowflake) } }
            red_picks.each { |red_pick| board.drop_disc(red_pick, fire) }
          end

          context 'when 4 fire discs are connected' do
            let(:red_picks) { [1, 2, 4] }
            let(:winning_pick) { 3 }

            it do
              color, col, row = board.drop_disc(winning_pick, fire)
              expect(game.win?(board, color, col, row)).to be true
            end
          end

          context 'when only 3 fire discs are connected' do
            let(:red_picks) { [1, 2] }
            let(:not_winning_red_pick) { 3 }

            it do
              color, col, row = board.drop_disc(not_winning_red_pick, fire)
              expect(game.win?(board, color, col, row)).to be false
            end
          end

          context 'when only 2 fire discs are connected' do
            let(:red_picks) { [1] }
            let(:not_winning_red_pick) { 2 }

            it do
              color, col, row = board.drop_disc(not_winning_red_pick, fire)
              expect(game.win?(board, color, col, row)).to be false
            end
          end

          context 'when there is only 1 fire disc' do
            let(:red_picks) { [] }
            let(:not_winning_red_pick) { 1 }

            it do
              color, col, row = board.drop_disc(not_winning_red_pick, fire)
              expect(game.win?(board, color, col, row)).to be false
            end
          end
        end

        context 'for backward-diagonal' do
          before do
            (1..3).each { |i| (4 - i).times { board.drop_disc(i, snowflake) } }
            red_picks.each { |red_pick| board.drop_disc(red_pick, fire) }
          end

          context 'when 4 fire discs are connected' do
            let(:red_picks) { [1, 2, 4] }
            let(:winning_pick) { 3 }

            it do
              color, col, row = board.drop_disc(winning_pick, fire)
              expect(game.win?(board, color, col, row)).to be true
            end
          end

          context 'when only 3 fire discs are connected' do
            let(:red_picks) { [1, 2] }
            let(:not_winning_red_pick) { 3 }

            it do
              color, col, row = board.drop_disc(not_winning_red_pick, fire)
              expect(game.win?(board, color, col, row)).to be false
            end
          end

          context 'when only 2 fire discs are connected' do
            let(:red_picks) { [1] }
            let(:not_winning_red_pick) { 2 }

            it do
              color, col, row = board.drop_disc(not_winning_red_pick, fire)
              expect(game.win?(board, color, col, row)).to be false
            end
          end

          context 'when there is only 1 fire disc' do
            let(:red_picks) { [] }
            let(:not_winning_red_pick) { 1 }

            it do
              color, col, row = board.drop_disc(not_winning_red_pick, fire)
              expect(game.win?(board, color, col, row)).to be false
            end
          end
        end
      end
    end

    context 'when there are fire discs on the first and last cols of the board' do
      let(:red_picks) { [0, 5, 6] }
      let(:not_winning_red_pick) { 1 }

      before do
        red_picks.each { |red_pick| board.drop_disc(red_pick, fire) }
      end

      it 'does not go around the board' do
        color, col, row = board.drop_disc(not_winning_red_pick, fire)
        expect(game.win?(board, color, col, row)).to be false
      end
    end
  end
end
