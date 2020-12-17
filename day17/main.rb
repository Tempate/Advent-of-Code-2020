gem "solid_assert"

file = File.open("input.txt")
$space = [file.readlines.map(&:chomp).map(&:chars)]


ACTIVE = '#'
INACTIVE = '.'


def count_cells_in_state(space, state)
    space.flatten.tally[state]
end


def find_neighbors(space, coords)
    subspace = space

    # Get all the in-bound indexes for each coordinate
    ranges = coords.map{ |c|
        max = [c + 1, subspace.length() - 1].min;
        min = [c - 1, 0].max;

        subspace = subspace[c];
        (min..max).to_a
    }

    # Get the values of all its neighbors
    # WARNING: It may not count some inactive squares
    ranges[0].product(*ranges[1..-1]).map{ |coords_| 
        get_subspace(space, coords_) unless coords == coords_
    }.compact
end


def run_automaton(space, iterations, dimensions)
    space = Marshal.load(Marshal.dump(space))

    iterations.times do
        space = update(expand(space), dimensions)
    end

    space
end


def update(space, dimensions, coordinates = [])
    subspace = get_subspace(space, coordinates)
    
    if coordinates.length() == dimensions
        return get_state(subspace, find_neighbors(space, coordinates).tally[ACTIVE])
    end
    
    subspace.map.with_index{ |subspace, coordinate|
        update(space, dimensions, coordinates + [coordinate])
    }
end


def expand(space)
    if space[0].is_a? String
        return [INACTIVE] + space + [INACTIVE]
    end

    space.map!{ |subspace| expand(subspace) }

    blank = inactive(space[0])

    space.unshift(blank).push(blank)
end


def inactive(space)
    if space[0].is_a? String
        return Array.new(space.length(), INACTIVE)
    end

    space.map{ |subspace| inactive(subspace) }
end


def get_subspace(space, coords)
    if coords == nil || coords.length() == 0
        return space
    end

    get_subspace(space[coords[0]], coords[1..-1])
end


def get_state(cell, neighbors)
    ((neighbors == 2 && cell == ACTIVE) || (neighbors == 3)) ? ACTIVE : INACTIVE
end


puts "Part 1: " + count_cells_in_state(run_automaton($space, 6, 3), ACTIVE).to_s
puts "Part 2: " + count_cells_in_state(run_automaton([$space], 6, 4), ACTIVE).to_s
