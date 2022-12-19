# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'

describe Game do
  subject(:game) { described_class.new(Board.new) }
  let(:red) { :red }
  let(:yellow) { :yellow }

  describe '#over?' do
    context 'when 4 red discs are aligned horizontally' do
      let(:picks) { [1, 2, 4] }
      let(:winning_pick) { 3 }

      before do
        picks.each { |pick| game.board.drop_disc(pick, red) }
      end

      it do
        color_and_coordinates = game.board.drop_disc(winning_pick, red)
        expect(game.over?(*color_and_coordinates)).to be true
      end
    end

    context 'when 4 yellow discs are aligned vertically' do
      let(:pick) { 3 }
      let(:winning_pick) { 3 }

      before do
        3.times { game.board.drop_disc(pick, yellow) }
      end

      it do
        color_and_coordinates = game.board.drop_disc(winning_pick, yellow)
        expect(game.over?(*color_and_coordinates)).to be true
      end
    end

    context 'when 4 yellow tokens are aligned diagonally' do
      let(:red_picks) { [2, 3, 3, 4, 4, 4] }
      let(:yellow_picks) { [*2..4] }
      let(:winning_yellow_pick) { 1 }

      before do
        red_picks.each { |red_pick| game.board.drop_disc(red_pick, red) }
        yellow_picks.each { |yellow_pick| game.board.drop_disc(yellow_pick, yellow) }
      end

      it do
        color_and_coordinates = game.board.drop_disc(winning_yellow_pick, yellow)
        expect(game.over?(*color_and_coordinates)).to be true
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
          color_and_coordinates = game.board.drop_disc(draw_pick, yellow)
          expect(game.over?(*color_and_coordinates)).to be true
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
