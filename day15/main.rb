file = File.open("input.txt")
numbers = file.read.split(',').map(&:to_i)


def run_game(numbers, max_length)
    hashmap = hashmap_from_list(numbers[0..-2])

    last_number = numbers.last()
    last_index = numbers.length() - 1

    while last_index + 1 < max_length

        if hashmap.has_key? last_number
            hashmap[last_number], last_number = last_index, last_index - hashmap[last_number]
        else
            hashmap[last_number], last_number = last_index, 0
        end
        
        last_index += 1
    end

    return last_number
end


def hashmap_from_list(list)
    return list.map.with_index{ |element, index|
        [element, index]
    }.to_h
end


puts "Part 1: " + run_game(numbers, 2020).to_s
puts "Part 2: " + run_game(numbers, 30000000).to_s
