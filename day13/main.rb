file = File.open("input.txt")
$input = file.readlines.map(&:chomp)


def parse(input)
    arrival = input[0].to_i

    schedules = input[1].split(',').map.with_index{ |bus_id, index|
        {:id => bus_id.to_i, :key => index} unless bus_id == 'x'
    }.compact

    return arrival, schedules
end


def find_soonest_bus(arrival, schedules)
    # Return [waiting_time, id] for every timestamp
    return schedules.map{ |schedule|
        [schedule[:id] - (arrival % schedule[:id]), schedule[:id]]
    }.min
end


arrival, schedules = parse($input)

puts "Part 1: " + (find_soonest_bus(arrival, schedules).inject(:*)).to_s
