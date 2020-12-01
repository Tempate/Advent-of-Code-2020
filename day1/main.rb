file = File.open("input.txt")
lines = file.readlines.map(&:chomp).map(&:to_i)

lines.each_with_index do |n1, i|
    lines[(i+1)..-1].each_with_index do |n2, j|
        lines[(j+1)..-1].each do |n3|
            if n1 + n2 + n3 == 2020 
                puts n1 * n2 * n3
            end
        end
    end
end
