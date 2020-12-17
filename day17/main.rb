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

    # Get the coordinates for its neighbors
    # WARNING: It may not count some inactive squares
    neighbors = ranges[0].product(*ranges[1..-1]).select{ |coords_| coords != coords_ }

    neighbors.map{ |coords_| get_subspace(space, coords_) }
end


def run_automaton(space, iterations, dimensions)
    space = Marshal.load(Marshal.dump(space))

    iterations.times do
        # Expand the space so that edge-nodes can activate
        space = expand(space)

        # Run the rules for every activatable cell in the space
        space = update(space, dimensions)
    end

    space
end


def update(space, dimensions, coordinates = [])
    subspace = get_subspace(space, coordinates)
    
    # The subspace is a point. Update its state!
    if coordinates.length() == dimensions
        return get_state(subspace, find_neighbors(space, coordinates).tally[ACTIVE])
    end
    
    # The subspace is not a point. Update all of its subspaces
    subspace.map.with_index{ |subspace, coordinate|
        update(space, dimensions, coordinates + [coordinate])
    }
end


def expand(space)
    if space[0].is_a? String
        return [INACTIVE] + space + [INACTIVE]
    end

    space.map!{ |subspace| expand(subspace) }

    inactive_subspace = inactive(space[0])

    # Add two inactive subspaces at the top and bottom of the space
    space.unshift(inactive_subspace).push(inactive_subspace)
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
