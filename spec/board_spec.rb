# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }
  let(:color) { :red }

  describe '#drop_disc' do
    let(:pick) { 4 }

    context 'when the pick is not filled' do
      it 'drops a disc' do
        expect { board.drop_disc(pick, color) }.to change { board.cols[pick].count(nil) }.by(-1)
      end
    end

    context 'when the pick is filled' do
      before do
        6.times { board.drop_disc(pick, color) }
      end

      it 'does not drop a disc' do
        expect { board.drop_disc(pick, color) }.not_to change { board.cols[pick].count(nil) }
      end
    end
  end

  describe '#valid_pick?' do
    context 'when the pick is valid' do
      let(:pick) { 4 }

      context 'when it is in the range 0..6 and it is not filled' do
        it { expect(board.valid_pick?(pick)).to be true }
      end
    end

    context 'when the pick is not valid' do
      context 'when it is not in the range 0..6' do
        let(:pick) { 8 }

        it { expect(board.valid_pick?(pick)).to be false }
      end

      context 'when it is in the range 0..6 and it is filled' do
        let(:pick) { 5 }

        before do
          6.times { board.drop_disc(pick, color) }
        end

        it { expect(board.valid_pick?(pick)).to be false }
      end
    end
  end

  describe '#filled?' do
    context 'when the board is filled' do
      before do
        7.times { |pick| 6.times { board.drop_disc(pick, color) } }
      end

      it { expect(board.filled?).to be true }
    end

    context 'when the board is not filled' do
      it { expect(board.filled?).to be false }
    end
  end
end
