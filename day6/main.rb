file = File.open("input.txt")
$groups = file.read.split("\n\n")


def count_different_letters(string)
    return string.chars.uniq.length()
end

def count_same_letters(strings)
    return strings.map(&:chars).inject(:&).length()
end

puts "Part 1: " + $groups.map{|group| count_different_letters(group.delete("\n"))}.inject(:+).to_s
puts "Part 2: " + $groups.map{|group| count_same_letters(group.split("\n"))}.inject(:+).to_s
