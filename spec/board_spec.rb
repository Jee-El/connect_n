# frozen_string_literal: true

require_relative '../lib/board/board'

describe ConnectFour::Board do
  subject(:board) { described_class.new }
  let(:color) { :red }

  describe '#drop_disc' do
    let(:pick) { 4 }
    let(:row) { 0 }

    context 'when the col is not filled' do
      it 'drops a disc' do
        expect { board.drop_disc(pick, color) }.to change { board.cols[pick].count(nil) }.by(-1)
      end

      it 'returns an array containing color, col, and row' do
        expect(board.drop_disc(pick, color)).to contain_exactly(color, pick, row)
      end
    end

    context 'when the col is filled' do
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

  describe '#at' do
    context 'when it receives a negative col value & a positive row value' do
      let(:negative_col) { -3 }
      let(:positive_row) { 4 }

      it do
        cell = board.at(negative_col, positive_row)
        expect(cell).to be_nil
      end
    end

    context 'when it receives a positive col value and a negative row value' do
      let(:positive_col) { 5 }
      let(:negative_row) { -74 }

      it do
        cell = board.at(positive_col, negative_row)
        expect(cell).to be_nil
      end
    end

    context 'when it receives a negative col value and a negative row value' do
      let(:negative_col) { -32 }
      let(:negative_row) { -2 }

      it do
        cell = board.at(negative_col, negative_row)
        expect(cell).to be_nil
      end
    end

    context 'when it receives a positive col value and a positive row value' do
      context 'when both the col value and row value are respectively IN ranges 0..6 0..5' do
        let(:in_range_positive_col) { 0 }
        let(:in_range_positive_row) { 2 }

        it do
          cell = board.at(in_range_positive_col, in_range_positive_row)
          expected_cell = board.cols.dig(in_range_positive_col, in_range_positive_row)
          expect(cell).to eq(expected_cell)
        end
      end

      context 'when both the col value and row value are respectively OUT of ranges 0..6 0..5' do
        let(:out_of_range_positive_col) { 12 }
        let(:out_of_range_positive_row) { 30 }

        it do
          cell = board.at(out_of_range_positive_col, out_of_range_positive_row)
          expect(cell).to be_nil
        end
      end

      context 'when the col value is OUT of range 0..6' do
        let(:out_of_range_positive_col) { 9 }
        let(:positive_row) { 4 }

        it do
          cell = board.at(out_of_range_positive_col, positive_row)
          expect(cell).to be_nil
        end
      end

      context 'when the row value is OUT of range 0..5' do
        let(:positive_col) { 5 }
        let(:out_of_range_positive_row) { 7 }

        it do
          cell = board.at(positive_col, out_of_range_positive_row)
          expect(cell).to be_nil
        end
      end
    end
  end
end
