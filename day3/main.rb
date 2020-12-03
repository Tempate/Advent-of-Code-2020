file = File.open("input.txt")
lines = file.readlines.map(&:chomp)

TREE = '#'
LINE_LENGTH = lines[0].length()


def count_trees(lines, slope, n = 0)
    if lines == nil || lines == []
        return 0
    end

    count = count_trees(lines[slope['y']..-1], slope, n + 1)
    
    if lines[0][slope['x'] * n % LINE_LENGTH] == TREE
        count += 1
    end
    
    return count 
end


counts = [
    count_trees(lines, {'x' => 1, 'y' => 1}),
    count_trees(lines, {'x' => 3, 'y' => 1}),
    count_trees(lines, {'x' => 5, 'y' => 1}),
    count_trees(lines, {'x' => 7, 'y' => 1}),
    count_trees(lines, {'x' => 1, 'y' => 2})
]


puts "Part 1: " + counts[1].to_s
puts "Part 2: " + counts.inject(:*).to_s
