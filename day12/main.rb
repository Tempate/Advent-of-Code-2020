file = File.open("input.txt")
$coordinates = file.readlines.map(&:chomp)


$DIRECTIONS = ["N", "E", "S", "W"]


def move_ship(direction, amount)
    case direction
    when "R"
        $ship[:dir] += amount / 90
        $ship[:dir] %= 4
    when "L"
        $ship[:dir] -= amount / 90
        $ship[:dir] %= 4
    when "F"
        move($ship, $DIRECTIONS[$ship[:dir]], amount)
    else
        move($ship, direction, amount)
    end
end


def move_ship_and_waypoint(direction, amount)
    case direction
    when "R"
        $waypoint = rotate($waypoint, amount)
    when "L"
        $waypoint = rotate($waypoint, 360 - (amount % 360))
    when "F"
        $ship[:lat] += amount * $waypoint[:lat]
        $ship[:lon] += amount * $waypoint[:lon]
    else
        move($waypoint, direction, amount)
    end
end


def move(position, direction, amount)
    case direction
    when "N"
        position[:lat] += amount
    when "E"
        position[:lon] += amount
    when "S"
        position[:lat] -= amount
    when "W"
        position[:lon] -= amount
    end
end


def rotate(position, amount)
    case amount % 360
    when 90
        position = {
            :lon =>  position[:lat],
            :lat => -position[:lon]
        }
    when 180
        position = {
            :lon => -position[:lon],
            :lat => -position[:lat]
        }
    when 270
        position = {
            :lon => -position[:lat],
            :lat =>  position[:lon]
        }
    end

    return position
end


def execute_coordinates(policy)
    $coordinates.each do |coordinate|
        info = coordinate.match(/(?<direction>(N|S|E|W|F|L|R){1})(?<amount>\d+)/)

        method(policy).call(info[:direction], info[:amount].to_i)
    end
end


def manhattan_distance(position)
    return position[:lon].abs + position[:lat].abs
end


$ship = {:lat => 0, :lon => 0, :dir => 1}

execute_coordinates(:move_ship)

puts "Part 1: " + manhattan_distance($ship).to_s


$ship     = {:lat => 0, :lon => 0,  :dir => 1}
$waypoint = {:lat => 1, :lon => 10, :dir => 0}

execute_coordinates(:move_ship_and_waypoint)

puts "Part 2: " + manhattan_distance($ship).to_s
