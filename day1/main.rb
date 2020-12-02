file = File.open("input.txt")
lines = file.readlines.map(&:chomp).map(&:to_i)


def f(numbers, count, result)
    if numbers.length() == 0
        return nil
    elsif count == 1
        first = numbers[0]

        if first == result
            return [first]
        elsif numbers.length() == 0
            return nil
        else
            return f(numbers.drop(1), count, result)
        end
    end

    first = numbers[0]
    numbers = numbers.drop(1)

    answer = f(numbers, count - 1, result - first)

    if answer == nil
        return f(numbers, count, result)
    else
        return answer.push(first)
    end
end


puts "Part 1: " + f(lines, 2, 2020).inject(:*).to_s
puts "Part 2: " + f(lines, 3, 2020).inject(:*).to_s
