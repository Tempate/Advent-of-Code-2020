file = File.open("input.txt")
$numbers = file.readlines.map(&:chomp).map(&:to_i)


PREAMBLE_SIZE = 25


# A number is valid if it's the sum of two different numbers from the list
def is_valid(list, number)
    list.each do |n|
        if n < number && list.include?(number - n)
            return true
        end
    end

    return false
end


def find_first_invalid_number()
    $numbers[PREAMBLE_SIZE..-1].each_with_index do |number, index|
        previous_numbers = $numbers[index..(index + PREAMBLE_SIZE - 1)]

        unless is_valid(previous_numbers, number)
            return number
        end
    end

    return false
end


def find_contiguous_set_that_adds_to_number(number)
    $numbers.each_with_index do |n, index|
        contiguous_set = [n]
        sum = n

        while sum < number
            index += 1

            sum += $numbers[index]
            contiguous_set.push($numbers[index])
        end

        if sum == number
            return contiguous_set
        end
    end

    return false
end


invalid_number = find_first_invalid_number()
contiguous_set = find_contiguous_set_that_adds_to_number(invalid_number)

puts "Part 1: " + invalid_number.to_s
puts "Part 2: " + (contiguous_set.min + contiguous_set.max).to_s
