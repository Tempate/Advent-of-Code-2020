file = File.open("input.txt")
$groups = file.read.split("\n\n")


def count_different_letters(string)
    string.chars.uniq.length()
end


def count_same_letters(strings)
    strings.map(&:chars).inject(:&).length()
end


puts "Part 1: " + $groups.sum{|group| count_different_letters(group.delete("\n"))}.to_s
puts "Part 2: " + $groups.sum{|group| count_same_letters(group.split("\n"))}.to_s
