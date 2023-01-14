# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'connect_n'
  s.version     = '0.0.5'
  s.summary     = 'Connect-N!'
  s.description =
    'A more general version of connect-4 where you try to connect N similar discs. It comes with several features and a friendly API that allows you to customize the game however you want!'
  s.authors     = ['Lhoussaine (Jee-El) Ghallou']
  s.email       = ''
  s.files       = [
    'lib/connect_n.rb',
    'lib/connect_n/board/board.rb',
    'lib/connect_n/game/game.rb',
    'lib/connect_n/demo/demo.rb',
    'lib/connect_n/player/player.rb',
    'lib/connect_n/player/computer_player/computer_player.rb',
    'lib/connect_n/player/human_player/human_player.rb',
    'lib/connect_n/prompt/prompt.rb',
    'lib/connect_n/winnable/winnable.rb'
  ]
  s.homepage =
    'https://github.com/Jee-El/connect_n'
  s.license = 'MIT'
  s.add_runtime_dependency 'tty-box', '~> 0.7.0'
  s.add_runtime_dependency 'tty-prompt', '~> 0.23.1'
  s.required_ruby_version = '>= 2.7.0'
end
