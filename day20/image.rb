class Image
    attr_reader :id, :view, :views

    def initialize(str)
        parts = str.split("\n")
        
        @id = parts[0].match(/Tile (?<id>\d+)/)[:id].to_i

        @view = parts[1..].map{ |row| row.chars }
        @views = permutations(@view)
    end

    def match(border, pos)
        matching_view = @views.select{ |view| get_border(view, pos) == border }

        if matching_view.length > 0
            @view = matching_view[0]
            return true
        end

        false
    end

    def print(view = @view)
        view.each{ |row| puts row.join() }
    end

    def print_views()
        @views.each{ |view| print(view); puts; }
    end
end


def permutations(view)
    (0..3).map{ |_|
        view = rotate(view)
        [view, flip(view)]
    }.flatten(1)
end


def rotate(view)
    max_x = view[0].length() - 1

    view.map.with_index{ |row, j|
        row.map.with_index{ |cell, i| 
            view[i][max_x - j]
        }
    } 
end


def flip(view)
    view.map{ |row| row.reverse() }
end
