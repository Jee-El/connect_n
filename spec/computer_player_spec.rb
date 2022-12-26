# frozen_string_literal: true

require_relative '../lib/player/computer_player/computer_player'
require_relative '../lib/board/board'

describe ConnectFour::ComputerPlayer do
  subject(:computer_player) { described_class.new(board) }
  let(:board) { ConnectFour::Board.new }
  let(:snowflake) { computer_player.disc }
  let(:fire) { computer_player.opponent_disc }

  describe '#pick' do
    context "when it is the computer's turn and it can win in one move" do
      let(:snowflake_picks) { [1, 2, 3] }
      let(:best_picks) { [0, 4] }

      before do
        snowflake_picks.each { |snowflake_pick| board.drop_disc(snowflake_pick, snowflake) }
      end

      it 'plays that move' do
        computer_player_pick = computer_player.pick
        expect(computer_player_pick).to eq(best_picks.first).or eq(best_picks.last)
      end
    end

    context "when it is the computer's turn and the other player can win in one move" do
      let(:fire_picks) { [0, 1, 2] }
      let(:best_pick) { 3 }

      before do
        fire_picks.each { |fire_pick| board.drop_disc(fire_pick, fire) }
      end

      it 'stops them from winning' do
        computer_player_pick = computer_player.pick
        expect(computer_player_pick).to eq(best_pick)
      end
    end
  end
end
