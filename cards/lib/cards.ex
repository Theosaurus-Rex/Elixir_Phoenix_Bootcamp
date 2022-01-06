# A module is a collection of methods
# Elixir has no concept of instance variables
# "Arity" is the number of arguments a function accepts
defmodule Cards do
  def create_deck do 
    values = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]
    #List comprehension - "for" loop
    #This is a mapping function
    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  def save(deck, filename) do 
    #Invoke erlang code with the colon
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> 
        :erlang.binary_to_term binary
      {:error, _reason} -> 
        "That file does not exist"
    end
  end

  def create_hand(hand_size) do
    # The created deck automatically gets injected as the first argument
    Cards.create_deck
    |> Cards.shuffle
    |> Cards.deal(hand_size)
  end
end
