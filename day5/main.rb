file = File.open("input.txt")
$lines = file.readlines.map(&:chomp)


def string_to_binary(string, char_for_one)
    binary_number = 0

    string.each_char do |char|
        binary_number <<= 1

        if char == char_for_one
            binary_number |= 1
        end
    end

    return binary_number
end


def seat_id(boarding_pass)
    row = string_to_binary(boarding_pass[0..6], 'B')
    col = string_to_binary(boarding_pass[7..-1], 'R')

    return row * 8 + col
end


$seat_ids = $lines.map{|boarding_pass| seat_id(boarding_pass) }.sort

def find_empty_seat(seat_ids)
    previous_seat = seat_ids.pop() - 1
    
    if previous_seat == seat_ids[-1]
        return find_empty_seat(seat_ids)
    end

    return previous_seat
end

puts "Part 1: " + $seat_ids[-1].to_s
puts "Part 2: " + find_empty_seat($seat_ids).to_s
