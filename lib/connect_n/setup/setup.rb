# frozen_string_literal: true

module ConnectN
  module Setup
    def self.ask_for_cols_amount(
      prompt: 'How many columns do you want in the board?',
      default: 7
    )
      PROMPT.ask prompt, convert: :int, default: default
    end

    def self.ask_for_rows_amount(
      prompt: 'How many rows do you want in the board?',
      default: 6
    )
      PROMPT.ask prompt, convert: :int, default: default
    end

    def self.ask_for_min_to_win(
      prompt: 'Minimum number of aligned similar discs necessary to win : ',
      default: 4
    )
      PROMPT.ask(prompt, convert: :int, default: default)
    end

    def self.ask_for_difficulty(prompt: 'Difficulty : ', levels: [*0..10])
      PROMPT.slider prompt, levels, default: default
    end

    def self.ask_for_mode(prompt: 'Choose a game mode : ')
      PROMPT.select(prompt, ['Single Player', 'Multiplayer']).downcase
    end

    def self.human_starts?(prompt: 'Do you wanna play first?')
      PROMPT.yes? prompt
    end

    def self.ask_for_disc(
      prompt: 'Enter a character that will represent your disc : ',
      default: '🔥',
      error_msg: 'Please enter a single character.'
    )
      PROMPT.ask prompt, default: default do |q|
        q.validate(/^.?$/)
        q.messages[:valid?] = error_msg
      end
    end

    def self.ask_for_name(prompt: 'Enter your name : ', default: ENV['USER'])
      PROMPT.ask prompt, default: default
    end
  end
end
