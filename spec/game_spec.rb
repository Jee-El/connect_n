require_relative '../lib/game'
require_relative '../lib/board'

describe Game do
  subject(:game) { described_class.new }
  let(:red) { 'red' }
  let(:yellow) { 'yellow' }

  describe '#over?' do
    context 'when 4 tokens of the same color are aligned horizontally' do
      let(:picks) { [*1..4] }

      before do
        picks.each { |pick| game.board.drop_disc(pick, red) } 
      end

      it { expect(game.over?).to be true }
    end

    context 'when 4 tokens of the same color are aligned vertically' do
      let(:pick) { 3 }

      before do
        4.times { game.board.drop_disc(pick, yellow) }
      end

      it { expect(game.over?).to be true }
    end

    context 'when 4 tokens of the same color are aligned diagonally' do
      let(:red_picks) { [*2..4] }
      let(:yellow_picks) { [*1..4] }

      before do
        red_picks.each { |red_pick| game.board.drop_disc(red_pick, red) }
        yellow_picks.each { |yellow_pick| game.board.drop_disc(yellow_pick, yellow) }
      end

      it { expect(game.over?).to be true }
    end

    context 'when there are no 4 tokens of the same color' do
      context 'if the board is filled' do
        before do
          allow(game.board).to receive(:filled?).and_return(true)
        end

        it { expect(game.over?).to be true }
      end

      context 'if the board is not filled' do
        before do
          allow(game.board).to receive(:filled?).and_return(false)
        end

        it { expect(game.over?).to be false }
      end
    end 
  end
end