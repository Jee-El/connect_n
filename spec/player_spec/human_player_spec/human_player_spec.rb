require_relative '../../../lib/connect_n/prompt/prompt'
require_relative '../../../lib/connect_n/player/human_player/human_player'

describe ConnectN::HumanPlayer do
  subject(:human_player) { described_class.new }

  describe '#pick' do
    context 'when the user wants to save the game' do
      let(:user_input) { ':W' }
      before do
        allow(ConnectN::PROMPT).to receive(:ask).and_return(user_input)
      end

      it 'returns :W downcased' do
        pick = human_player.pick
        expect(pick).to eq(user_input.downcase)
      end
    end

    context 'when the user enters a column number' do
      let(:user_input) { '4' }

      before do
        allow(ConnectN::PROMPT).to receive(:ask).and_return(user_input)
      end

      it 'returns an Integer' do
        input = human_player.pick
        expect(input).to be_an(Integer)
      end

      it 'returns that number minus one' do
        input = human_player.pick
        expect(input).to eq(user_input.to_i - 1)
      end
    end
  end
end
