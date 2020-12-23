file = File.open("input.txt")
lines = file.readlines.map(&:chomp)


def policy1(pos1, pos2, letter, string)
    (pos1..pos2).cover? string.count(letter)
end


def policy2(pos1, pos2, letter, string)
    (string[pos1-1] == letter) ^ (string[pos2-1] == letter)
end


def valid_passwords(lines, policy)
    pattern = Regexp.compile(/^(?<pos1>\d+)-(?<pos2>\d+) (?<letter>[a-z]{1}): (?<string>[a-z]+)$/)

    lines.select{ |line|
        content = pattern.match(line);
        method(policy).call(content[1].to_i, content[2].to_i, content[3], content[4])
    }.length()
end


puts "Part 1: " + valid_passwords(lines, :policy1).to_s
puts "Part 2: " + valid_passwords(lines, :policy2).to_s
