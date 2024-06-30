require_relative 'hangman'

SAVES_FILENAME  = "saves.json"
game = Hangman.new


puts "Would you like to load a previous run? Y or N"
choice = gets.chomp.upcase


if choice == "Y"
  game.load_game(SAVES_FILENAME)
else
  game.choose_secret_word
end

until game.win_lose_message do

  game.save_game(SAVES_FILENAME)
  guessed_letter = game.guess_a_letter
  game.check_guess(guessed_letter)
  game.display_secret_word
  
end
