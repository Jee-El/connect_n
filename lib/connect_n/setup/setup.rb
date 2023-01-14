

module ConnectN
  module Setup

    def self.ask_for_cols_amount
      PROMPT.ask 'How many columns do you want in the board?', convert: :int, default: 7
    end

    def self.ask_for_rows_amount
      PROMPT.ask 'How many rows do you want in the board?', convert: :int, default: 6
    end

    def self.ask_for_min_to_win
      PROMPT.ask(
        'Minimum number of aligned similar discs necessary to win : ',
        convert: :int,
        default: 4
      )
    end

    def self.ask_for_difficulty
      PROMPT.slider 'Difficulty : ', [*0..10], default: 0
    end

    def self.ask_for_mode
      PROMPT.select('Choose a game mode : ', ['Single Player', 'Multiplayer']).downcase
    end

    def self.human_starts?
      PROMPT.yes? 'Do you wanna play first?'
    end

    def self.ask_for_disc
      PROMPT.ask 'Enter a character that will represent your disc : ', default: '🔥' do |q|
        q.validate(/^.?$/)
        q.messages[:valid?] = 'Please enter a single character.'
      end
    end

    def self.ask_for_human_name
      PROMPT.ask 'Enter your name : ', default: ENV['USER']
    end
  end
end
