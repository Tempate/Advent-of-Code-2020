file = File.open("input.txt")
lines = file.readlines.map(&:chomp)


def first_policy(min, max, letter, string)
    count = string.count(letter)
    return count >= min && count <= max
end


def second_policy(min, max, letter, string)
    first_char = string[min-1] == letter
    second_char = string[max-1] == letter
    return (first_char && !second_char) || (second_char && !first_char)
end


def valid_passwords(lines, policy)
    valid = 0

    lines.each do |line|
        parts = line.split(' ')
        
        margins = parts[0].split('-')
        min = margins[0].to_i
        max = margins[1].to_i

        letter = parts[1][0]

        if method(policy).call(min, max, letter, parts[2])
            valid += 1
        end
    end

    return valid
end


puts "Part 1: " + valid_passwords(lines, :first_policy).to_s
puts "Part 2: " + valid_passwords(lines, :second_policy).to_s
