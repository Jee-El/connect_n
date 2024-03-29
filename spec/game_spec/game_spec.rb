# frozen_string_literal: true

require 'yaml'

require_relative '../../lib/connect_n/game/game'
require_relative '../../lib/connect_n/board/board'
require_relative '../../lib/connect_n/player/human_player/human_player'
require_relative '../../lib/connect_n/player/computer_player/computer_player'

describe ConnectN::Game do
  subject(:game) { described_class.new(board: board, first_player: human_player, second_player: computer_player) }

  let(:board) { ConnectN::Board.new }
  let(:human_player) { instance_double(ConnectN::HumanPlayer, disc: '🔥') }
  let(:computer_player) { instance_double(ConnectN::ComputerPlayer, disc: '🧊') }

  let(:fire) { human_player.disc }
  let(:ice) { computer_player.disc }

  describe '#over?' do
    let(:row_num) { -Float::INFINITY }
    let(:col_num) { -Float::INFINITY }
    let(:no_disc) { :no_disc }

    context 'when a player has won' do
      before { allow(game).to receive(:win?).and_return(true) }

      it do
        expect(game).to receive(:win?).once
        game.over?(board, -Float::INFINITY, -Float::INFINITY, :no_disc)
      end

      it do
        expect(board).not_to receive(:filled?)
        game.over?(board, row_num, col_num, no_disc)
      end

      it { expect(game.over?(board, row_num, col_num, no_disc)).to be true }
    end

    context 'when a player has not won' do
      before { allow(game).to receive(:win?).and_return(false) }

      context 'when the board is filled' do
        before { allow(board).to receive(:filled?).and_return(true) }

        it do
          expect(game).to receive(:win?).once
          game.over?(board, row_num, col_num, no_disc)
        end

        it do
          expect(board).to receive(:filled?).once
          game.over?(board, row_num, col_num, no_disc)
        end

        it { expect(game.over?(board, row_num, col_num, no_disc)).to be true }
      end

      context 'when the board is not filled' do
        before { allow(board).to receive(:filled?).and_return(false) }

        it do
          expect(game).to receive(:win?).once
          game.over?(board, row_num, col_num, no_disc)
        end

        it do
          expect(board).to receive(:filled?).once
          game.over?(board, row_num, col_num, no_disc)
        end

        it { expect(game.over?(board, row_num, col_num, no_disc)).to be false }
      end
    end
  end

  describe '#win?' do
    context 'when no fire disc is on the first or last col of the board' do
      context 'for horizonal' do
        before { fire_picks.each { |fire_pick| board.drop_disc(fire, at_col: fire_pick) } }

        context 'when 4 fire discs are connected' do
          let(:fire_picks) { [1, 2, 4] }
          let(:winning_pick) { 3 }

          it 'returns true' do
            row_num, col_num = board.drop_disc(fire, at_col: winning_pick)
            expect(game.win?(board, row_num, col_num, fire)).to be true
          end
        end

        context 'when only 3 fire discs are connected' do
          let(:fire_picks) { [1, 2] }
          let(:not_winning_fire_pick) { 3 }

          it do
            row_num, col_num = board.drop_disc(fire, at_col: not_winning_fire_pick)
            expect(game.win?(board, row_num, col_num, fire)).to be false
          end
        end

        context 'when only 2 fire discs are connected' do
          let(:fire_picks) { [1] }
          let(:not_winning_fire_pick) { 2 }

          it do
            row_num, col_num = board.drop_disc(fire, at_col: not_winning_fire_pick)
            expect(game.win?(board, row_num, col_num, fire)).to be false
          end
        end

        context 'when there is only 1 fire disc' do
          let(:fire_picks) { [] }
          let(:not_winning_fire_pick) { 1 }

          it do
            row_num, col_num = board.drop_disc(fire, at_col: not_winning_fire_pick)
            expect(game.win?(board, row_num, col_num, fire)).to be false
          end
        end
      end

      context 'for vertical' do
        before { fire_picks.each { |fire_pick| board.drop_disc(fire, at_col: fire_pick) } }

        context 'when 4 fire discs are connected' do
          let(:fire_picks) { [5] * 3 }
          let(:winning_pick) { 5 }

          it do
            row_num, col_num = board.drop_disc(fire, at_col: winning_pick)
            expect(game.win?(board, row_num, col_num, fire)).to be true
          end
        end

        context 'when only 3 fire discs are connected' do
          let(:fire_picks) { [5] * 2 }
          let(:not_winning_fire_pick) { 5 }

          it do
            row_num, col_num = board.drop_disc(fire, at_col: not_winning_fire_pick)
            expect(game.win?(board, row_num, col_num, fire)).to be false
          end
        end

        context 'when only 2 fire discs are connected' do
          let(:fire_picks) { [5] }
          let(:not_winning_fire_pick) { 5 }

          it do
            row_num, col_num = board.drop_disc(fire, at_col: not_winning_fire_pick)
            expect(game.win?(board, row_num, col_num, fire)).to be false
          end
        end

        context 'when there is only 1 fire disc' do
          let(:fire_picks) { [] }
          let(:not_winning_fire_pick) { 5 }

          it do
            row_num, col_num = board.drop_disc(fire, at_col: not_winning_fire_pick)
            expect(game.win?(board, row_num, col_num, fire)).to be false
          end
        end
      end

      context 'for diagonal' do
        context 'for forward-diagonal' do
          before do
            (1..3).each { |i| i.times { board.drop_disc(ice, at_col: i + 1) } }
            fire_picks.each { |fire_pick| board.drop_disc(fire, at_col: fire_pick) }
          end

          context 'when 4 fire discs are connected' do
            let(:fire_picks) { [1, 2, 4] }
            let(:winning_pick) { 3 }

            it do
              row_num, col_num = board.drop_disc(fire, at_col: winning_pick)
              expect(game.win?(board, row_num, col_num, fire)).to be true
            end
          end

          context 'when only 3 fire discs are connected' do
            let(:fire_picks) { [1, 2] }
            let(:not_winning_fire_pick) { 3 }

            it do
              row_num, col_num = board.drop_disc(fire, at_col: not_winning_fire_pick)
              expect(game.win?(board, row_num, col_num, fire)).to be false
            end
          end

          context 'when only 2 fire discs are connected' do
            let(:fire_picks) { [1] }
            let(:not_winning_fire_pick) { 2 }

            it do
              row_num, col_num = board.drop_disc(fire, at_col: not_winning_fire_pick)
              expect(game.win?(board, row_num, col_num, fire)).to be false
            end
          end

          context 'when there is only 1 fire disc' do
            let(:fire_picks) { [] }
            let(:not_winning_fire_pick) { 1 }

            it do
              row_num, col_num = board.drop_disc(fire, at_col: not_winning_fire_pick)
              expect(game.win?(board, row_num, col_num, fire)).to be false
            end
          end
        end

        context 'for backward-diagonal' do
          before do
            (1..3).each { |i| (4 - i).times { board.drop_disc(ice, at_col: i) } }
            fire_picks.each { |fire_pick| board.drop_disc(fire, at_col: fire_pick) }
          end

          context 'when 4 fire discs are connected' do
            let(:fire_picks) { [1, 2, 4] }
            let(:winning_pick) { 3 }

            it do
              row_num, col_num = board.drop_disc(fire, at_col: winning_pick)
              expect(game.win?(board, row_num, col_num, fire)).to be true
            end
          end

          context 'when only 3 fire discs are connected' do
            let(:fire_picks) { [1, 2] }
            let(:not_winning_fire_pick) { 3 }

            it do
              row_num, col_num = board.drop_disc(fire, at_col: not_winning_fire_pick)
              expect(game.win?(board, row_num, col_num, fire)).to be false
            end
          end

          context 'when only 2 fire discs are connected' do
            let(:fire_picks) { [1] }
            let(:not_winning_fire_pick) { 2 }

            it do
              row_num, col_num = board.drop_disc(fire, at_col: not_winning_fire_pick)
              expect(game.win?(board, row_num, col_num, fire)).to be false
            end
          end

          context 'when there is only 1 fire disc' do
            let(:fire_picks) { [] }
            let(:not_winning_fire_pick) { 1 }

            it do
              row_num, col_num = board.drop_disc(fire, at_col: not_winning_fire_pick)
              expect(game.win?(board, row_num, col_num, fire)).to be false
            end
          end
        end
      end
    end

    context 'when there are fire discs on the first and last cols of the board' do
      let(:fire_picks) { [0, 5, 6] }
      let(:not_winning_fire_pick) { 1 }

      before do
        fire_picks.each { |fire_pick| board.drop_disc(fire, at_col: fire_pick) }
      end

      it 'does not go around the board' do
        row_num, col_num = board.drop_disc(fire, at_col: not_winning_fire_pick)
        expect(game.win?(board, row_num, col_num, fire)).to be false
      end
    end
  end

  describe '.load' do
    let(:file_name) { 'saved_games' }
    let(:game_name) { 'game_1' }

    context 'if there is no such saved game' do
      before do
        allow(YAML).to receive(:safe_load_file)
      end

      it do
        deserialized_game = described_class.load(
          game_name, file_name
        )
        expect(deserialized_game).to be_nil
      end
    end

    context 'if there is such a saved game' do
      before do
        allow(YAML).to receive(:safe_load_file).and_return({ game_name.to_sym => game })
      end

      it 'returns a Game instance' do
        deserialized_game = described_class.load(
          game_name,
          file_name
        )
        expect(deserialized_game).to be_an(described_class)
      end
    end
  end

  describe '.resume' do
    before do
      allow(game).to receive(:play)
    end

    it 'calls Game#play on the passed-in game instance' do
      expect(game).to receive(:play).once
      described_class.resume game
    end
  end

  describe '.save?' do
    context 'when the user wants to save' do
      let(:user_input) { ':w' }

      it { expect(described_class.save?(user_input)).to be true }
    end

    context 'when the user does not want to save' do
      let(:user_input) { '5' }

      it { expect(described_class.save?(user_input)).to be false }
    end
  end

  describe '.save' do
    let(:file_name) { 'saved_games' }
    let(:game_name) { 'game_1' }

    before do
      allow(YAML).to receive(:safe_load_file)
      allow(YAML).to receive(:dump)
      allow(File).to receive(:write)
    end

    it 'serializes the game object' do
      expect(File)
        .to receive(:write)
        .with(file_name, any_args)
        .once
      described_class.save(game, game_name, file_name)
    end
  end
end
