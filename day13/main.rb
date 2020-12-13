file = File.open("input.txt")
$input = file.readlines.map(&:chomp)


def parse(input)
    arrival = input[0].to_i

    schedules = input[1].split(',').map.with_index{ |id, index|
        {:id => id.to_i, :key => (id.to_i - index) % id.to_i} unless id == 'x'
    }.compact

    return arrival, schedules
end


def find_soonest_bus(arrival, schedules)
    # Return [waiting_time, id] for every timestamp
    return schedules.map{ |schedule|
        [schedule[:id] - (arrival % schedule[:id]), schedule[:id]]
    }.min
end


# An implementation of the Chinese Remainder Theorem
def find_arrival_for_continuous_buses(schedules)
    max_index = schedules.length() - 1

    # We start by multiplying all the schedule ids
    # It's the amount of time it takes for the schedule sequence to repeat
    product = schedules.map{ |schedule| schedule[:id] }.inject(:*)

    # The coefficient of each cell should be 0 mod id, for every id that's not the cell's,
    # and key mod id — to make buses continuous —, for its own.
    number = (0..max_index).map{ |index|
        find_multiple_with_remainder(product / schedules[index][:id], schedules[index][:id], schedules[index][:key])
    }.inject(:+)

    return number % product
end


def find_multiple_with_remainder(number, modulus, remainder)
    number0 = number
    
    until number % modulus == remainder
        number += number0
    end

    return number
end



arrival, schedules = parse($input)

puts "Part 1: " + (find_soonest_bus(arrival, schedules).inject(:*)).to_s
puts "Part 2: " + find_arrival_for_continuous_buses(schedules).to_s