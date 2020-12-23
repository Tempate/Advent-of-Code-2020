file = File.open("input.txt")
space = [file.readlines.map(&:chomp).map(&:chars)]


ACTIVE = '#'
INACTIVE = '.'


def parse(input, input_dimensions, space_dimensions)
    coords = Array.new(space_dimensions - input_dimensions, 0)

    points_in_state(input, ACTIVE, space_dimensions, coords).flatten(input_dimensions - 1)
end


def points_in_state(space, state, dimensions, coords = [])
    if coords.length() == dimensions
        return (space == ACTIVE) ? coords : nil
    end

    space.map.with_index{ |subspace, coord|
        points_in_state(subspace, state, dimensions, coords + [coord])
    }.compact
end


def find_neighbors(space, coords)
    # Generate all the possible deviations for a given coordinate
    deltas = [-1..1].repeated_permutation(coords.length()) - [Array.new(coords.length(), 0)]

    # Get the coordinates of all its neighbors
    neighbors = deltas.map{ |delta| coords.zip(delta).map(&:sum) }

    neighbors.map{ |coords_| (space.include? coords_) ? ACTIVE : INACTIVE }
end


def run_automaton(space, iterations, dimensions)
    space = Marshal.load(Marshal.dump(space))

    iterations.times do
        size = get_size(space, dimensions)

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


def expand(size)
    size.map{ |limits| {:min => limits[:min] - 1, :max => limits[:max] + 1} }
end


def get_size(space, dimensions)
    (0..dimensions).map{ |i| 
        values = space.map{ |coords| coords[i] };
        {:min => values.min, :max => values.max}
    }
end


def get_state(cell, neighbors)
    ((neighbors == 2 && cell == ACTIVE) || (neighbors == 3)) ? ACTIVE : INACTIVE
end


space = parse(space, 3, 3).length()

#puts "Part 1: " + count_cells_in_state(run_automaton($space, 6, 3), ACTIVE).to_s
#puts "Part 2: " + count_cells_in_state(run_automaton([$space], 6, 4), ACTIVE).to_s
