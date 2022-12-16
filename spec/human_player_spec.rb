# frozen_string_literal: true

require_relative 'shared_examples_for_player'
require_relative '../lib/human_player'

describe HumanPlayer do
  describe '#pick' do
    it 'calls #gets' do
      allow(subject).to receive(:gets)
      expect(subject).to receive(:gets)
      subject.pick
    end
  end
end
