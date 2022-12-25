# frozen_string_literal: true

require_relative '../lib/player/computer_player/computer_player'
require_relative '../lib/board/board'

describe ConnectFour::ComputerPlayer do
  subject(:computer_player) { described_class.new(board) }
  let(:board) { ConnectFour::Board.new }
  let(:yellow) { computer_player.color }
  let(:red) { computer_player.opponent_color }

  describe '#pick' do
    context "when it is the computer's turn and it can win in one move" do
      let(:yellow_picks) { [1, 2, 3] }
      let(:best_picks) { [0, 4] }

      before do
        yellow_picks.each { |yellow_pick| board.drop_disc(yellow_pick, yellow) }
      end

      it 'plays that move' do
        computer_player_pick = computer_player.pick
        expect(computer_player_pick).to eq(best_picks.first).or eq(best_picks.last)
      end
    end

    context "when it is the computer's turn and the other player can win in one move" do
      let(:red_picks) { [0, 1, 2] }
      let(:best_pick) { 3 }

      before do
        red_picks.each { |red_pick| board.drop_disc(red_pick, red) }
      end

      it 'stops them from winning' do
        computer_player_pick = computer_player.pick
        expect(computer_player_pick).to eq(best_pick)
      end
    end
  end
end
