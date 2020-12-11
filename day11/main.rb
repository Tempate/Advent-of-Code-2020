file = File.open("input.txt")
$seats = file.readlines.map(&:chomp).map(&:chars)

MAX_X = $seats[0].length()
MAX_Y = $seats.length()

OCCUPIED = '#'
EMPTY = 'L'
FLOOR = '.'


$dirs = [[0, 1], [0, -1], [1, 0], [1, 1], [1, -1], [-1, 0], [-1, 1], [-1, -1]]


def find_neighbors(seats, x, y)
    return $dirs.map{|dir_x, dir_y| seats[y + dir_y][x + dir_x] if (x + dir_x).between?(0, MAX_X-1) && (y + dir_y).between?(0, MAX_Y-1)}.compact
end


def find_visible(seats, x, y)
    return $dirs.map{|dir_x, dir_y| find_element_in_direction(seats, x, y, dir_x, dir_y)}
end


def find_element_in_direction(seats, seat_x, seat_y, dir_x, dir_y)
    x = seat_x + dir_x
    y = seat_y + dir_y

    while 0 <= x && x < MAX_X && 0 <= y && y < MAX_Y do
        return seats[y][x] unless seats[y][x] == FLOOR

        x += dir_x
        y += dir_y
    end
    
    return FLOOR
end


def apply_rules_to_seat(neighbors, seat)
    empty = neighbors.count(EMPTY)
    floor = neighbors.count(FLOOR)

    seats_count = neighbors.length() - floor
    occupied = seats_count - empty

    if empty == seats_count
        return OCCUPIED
    elsif occupied >= $crowded
        return EMPTY
    end

    return seat
end


def apply_rules(seats, policy)
    new_seats = []
    changed = false

    seats.each_with_index do |seat_row, y|
        new_seat_row = []

        seat_row.each_with_index do |seat, x|
            new_seat = seat

            unless seat == FLOOR
                neighbors = method(policy).call(seats, x, y)
                
                new_seat = apply_rules_to_seat(neighbors, seat)

                changed = true unless new_seat == seat
            end

            new_seat_row.push(new_seat)
        end

        new_seats.push(new_seat_row)
    end

    return new_seats, changed
end


def find_stable_state(seats, policy)
    changed = true

    while changed
        seats, changed = apply_rules(seats, policy)
    end

    return seats
end


$crowded = 4
stable = find_stable_state($seats, :find_neighbors)

puts "Part 1: " + stable.flatten.count(OCCUPIED).to_s


$crowded = 5
stable = find_stable_state($seats, :find_visible)

puts "Part 2: " + stable.flatten.count(OCCUPIED).to_s
