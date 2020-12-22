require 'set'


file = File.open("input.txt")
input = file.read.split("\n\n")


def parse(input)
    input.map{ |player| player.split("\n")[1..].map(&:to_i) }
end


def run_game1(decks)
    until stop_playing(decks)
        highest_wins(decks, decks.map(&:shift))
    end
    
    decks
end


def run_game2(decks)
    history = Set.new

    until stop_playing(decks)
        # The first player wins when reaching an already played position
        if history.include? decks[0]
            return [decks[0], []]
        end

        # Save decks to history
        history.add(Array.new(decks[0]))

        cards = decks.map(&:shift)

        if play_subgame(decks, cards)
            subdecks = decks.map.with_index{ |deck, i| deck[..cards[i]-1] }

            if run_game2(subdecks)[0].length > 0
                decks[0].push(cards[0], cards[1])
            else
                decks[1].push(cards[1], cards[0])
            end

        else
            highest_wins(decks, cards)
        end
    end

    decks
end


def highest_wins(decks, cards)
    if (cards[0] > cards[1])
        decks[0].push(cards[0], cards[1])
    else
        decks[1].push(cards[1], cards[0])
    end
end


def stop_playing(decks)
    decks.map(&:length).include? 0
end


def play_subgame(decks, cards)
    decks.each_with_index.all? { |deck, i| cards[i] <= deck.length }
end


def score(deck)
    deck.reverse.map.with_index{ |card, index| card * (index + 1) }.inject(:+)
end


puts "Part 1: " + score(run_game1(parse(input)).max).to_s
puts "Part 2: " + score(run_game2(parse(input)).max).to_s
