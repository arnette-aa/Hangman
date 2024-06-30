require 'json'

MAX_GUESSES = 14

class Hangman
  def initialize
    @words = File.readlines('google-10000-english-no-swears.txt.1')
    @list_of_guesses = []
    num_guesses = MAX_GUESSES
    @secret_word = []
    @secret_word_letters = []
    @display_secret_word = []
  end

  def choose_secret_word
    selected_words = @words.select { |word| word.chomp.length.between?(5, 12) }
    @secret_word = selected_words.sample.chomp
    @secret_word_letters = @secret_word.split('')
    @display_secret_word = Array.new(@secret_word_letters.length, '_')
  end

  def guess_a_letter
    puts "Guess a letter:"
    guessed_letter = gets.chomp.downcase
    until guessed_letter.match?(/[a-z]/) && guessed_letter.length == 1
      puts "Invalid input. Please guess a single letter:"
      guessed_letter = gets.chomp.downcase
    end
    guessed_letter
  end

  def check_guess(guessed_letter)
    if @secret_word_letters.include?(guessed_letter) && !@display_secret_word.include?(guessed_letter)
      @secret_word_letters.each_with_index do |letter, index|
        if letter == guessed_letter
          @display_secret_word[index] = letter
          @list_of_guesses << guessed_letter
          @num_guesses -= 1
        end
      end
    elsif @display_secret_word.include?(guessed_letter)
      puts "Letter '#{guessed_letter}' was already chosen."
      # Handle this case appropriately
    else
      @list_of_guesses << guessed_letter
      puts "Letter '#{guessed_letter}' is not found in the secret word."
      puts "You have #{@num_guesses} left."
    end
  end

  def display_secret_word
    puts "Secret word: #{@display_secret_word.join(' ')}"

    #used to check word
    #puts "secret word: #{@secret_word}"
  end

  def win_lose_message
    if @secret_word_letters == @display_secret_word
      puts "Congratulations! You guessed '#{@secret_word_letters.join}' correctly."
      return true
    elsif @num_guesses == 0
      puts "You lose. The secret word was '#{@secret_word_letters.join}'."
      return true
    else
      return false
    end
  end

  def save_game(filename)
    puts "Would you like to save the game?"
    choice = gets.chomp.upcase
    if choice == "Y"  
      game_state = {
        secret_word: @secret_word,
        secret_word_letters: @secret_word_letters,
        display_secret_word: @display_secret_word,
        list_of_guesses: @list_of_guesses,
        num_guesses: @num_guesses
        # Add other game state attributes as needed
      }

      begin
        File.open(filename, 'w') do |file|
          file.write(JSON.dump(game_state)) # Serialize game_state to JSON and write to file
        end

        puts "Game saved successfully."
        exit #exits game
      rescue StandardError => e
        puts "Error saving game: #{e.message}"
      end
    end
  end

  def load_game(filename)
    begin
      saved_game = JSON.parse(File.read(filename))
      @secret_word = saved_game['secret_word']
      @secret_word_letters = saved_game['secret_word_letters']
      @display_secret_word = saved_game['display_secret_word']
      @list_of_guesses = saved_game['list_of_guesses']
      @num_guesses = saved_game['num_guesses']

      puts "Game loaded successfully."
    rescue StandardError => e
      puts "Error loading game: #{e.message}"
    end
  end
end