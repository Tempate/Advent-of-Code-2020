file = File.open("input.txt")
$adapters = file.readlines.map(&:chomp).map(&:to_i).sort

$adapters = [0] + $adapters + [$adapters.max + 3]


def count_jumps()
    count = [0, 0, 0]

    $adapters[0..-2].each_with_index do |adapter, index|
        jump = $adapters[index + 1] - adapter
        count[jump - 1] += 1
    end

    return count
end


# An arrangement is valid if all adapters are within a 1-3 range of eachother
def count_arrangements(adapters)
    len = adapters.length()

    return [1] if 0 <= len && len <= 2

    arrangements = count_arrangements(adapters[1..-1])

    new_arrangements = arrangements[0]

    if len >= 3 && adapters[2] - adapters[0] <= 3
        new_arrangements += arrangements[1]
    end
    
    if len >= 4 && adapters[3] - adapters[0] <= 3
        new_arrangements += arrangements[2]
    end

    return [new_arrangements] + arrangements
end


jumps = count_jumps()

puts "Part 1: " + (jumps[0] * jumps[2]).to_s
puts "Part 2: " + count_arrangements($adapters)[0].to_s
