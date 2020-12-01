file = File.open("input.txt")
lines = file.readlines.map(&:chomp).map(&:to_i)


def f(list, count, result)
    if list.length() == 0
        return nil
    elsif count == 1
        first = list[0]

        if first == result
            return [first]
        elsif list.length() == 0
            return nil
        else
            return f(list.drop(1), count, result)
        end
    end

    first = list[0]
    list = list.drop(1)

    answer = f(list, count - 1, result - first)

    if answer == nil
        return f(list, count, result)
    else
        return answer.push(first)
    end
end


puts "Part 1: " + f(lines, 2, 2020).inject(:*).to_s
puts "Part 2: " + f(lines, 3, 2020).inject(:*).to_s
