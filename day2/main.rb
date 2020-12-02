file = File.open("input.txt")
lines = file.readlines.map(&:chomp)


def policy1(pos1, pos2, letter, string)
    count = string.count(letter)
    return count >= pos1 && count <= pos2
end


def policy2(pos1, pos2, letter, string)
    char1 = string[pos1-1] == letter
    char2 = string[pos2-1] == letter
    return (char1 && !char2) || (!char1 && char2)
end


def valid_passwords(lines, policy)
    pattern = Regexp.compile(/^(?<pos1>\d+)-(?<pos2>\d+) (?<letter>[a-z]{1}): (?<string>[a-z]+)$/)
    
    valid = 0

    lines.each do |line|
        content = pattern.match(line)

        if method(policy).call(content[1].to_i, content[2].to_i, content[3], content[4])
            valid += 1
        end
    end

    return valid
end


puts "Part 1: " + valid_passwords(lines, :policy1).to_s
puts "Part 2: " + valid_passwords(lines, :policy2).to_s
