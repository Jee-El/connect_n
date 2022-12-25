# frozen_string_literal: true

require_relative '../lib/player/human_player/human_player'

describe ConnectFour::HumanPlayer do
  subject(:human_player) { described_class.new }

  describe '#pick' do
    let(:input) { '5' }

    before { allow(human_player).to receive(:gets).and_return(input) }

    it 'calls #gets' do
      expect(human_player).to receive :gets
      human_player.pick
    end

    it 'returns an integer' do
      expect(human_player.pick).to be_an Integer
    end

    it 'returns user input minus 1' do
      expect(human_player.pick).to eq input.to_i - 1
    end
  end
end
