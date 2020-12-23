numbers = File.read("input.txt").chars.map(&:to_i)


def run_game(numbers, iterations)
  iterations.times do
    current = numbers[0]
    group = numbers.slice!(1, 3)

    previous = highest_not_in_group(current - 1, group)
    destination = (previous >= 1) ? previous : numbers.max
    
    pos = numbers.index(destination)
    
    numbers = numbers.insert(pos + 1, *group)
    numbers.rotate!
  end

  numbers.rotate(numbers.index(1))[1..]
end


def highest_not_in_group(number, group)
  while group.include? number
    number -= 1
  end

  number
end


missing = (numbers.max..1000000).to_a


puts "Part 1: " + run_game(Array.new(numbers), 100).map(&:to_s).join()
puts "Part 2: " + run_game(numbers.concat(missing), 1000)[0..1].inject(:*).join()