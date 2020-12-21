require_relative "image"

file = File.open("input.txt")
images = file.read.split("\n\n")


$complementary = {
    :top => :bottom,
    :right => :left,
    :bottom => :top,
    :left => :right
}


def assemble(images)
    mosaic = [[ images[0] ]]
    images = images[1..]

    while images.length > 0
        [:top, :bottom, :right, :left].each{ |pos|
            border_images = get_border(mosaic, pos)

            new_border_images = border_images.map{ |border_image|
                border = get_border(border_image.view, pos)
                find_match(images, border, $complementary[pos])
            }

            unless new_border_images.include? false
                images -= new_border_images
                add_border(mosaic, new_border_images, pos)
            end
        }
    end

    mosaic
end


def find_match(images, border, pos)
    images.each{ |image|
        return image if image.match(border, pos)
    }

    false
end


def mosaic_to_views(mosaic)
    @view = @view

    view = mosaic.map{ |row|
        row.map{ |image| image.view[1..-2].map{ |row| row[1..-2] }.transpose }.inject(:+).transpose
    }.flatten(1)

    permutations(view)
end


def waters_roughness(views)
    views.each{ |view|
        n = count_sea_monsters(view)
        return count(view, "#") - 15 * n if n > 0
    }

    return 0
end


def count_sea_monsters(view)
    view[..-3].map.with_index { |row, j|
        row[..-20].select.with_index { |char, i|
            is_a_monster([
                view[j][i..i+19],
                view[j+1][i..i+19],
                view[j+2][i..i+19]
            ])
        }.length
    }.compact.inject(:+)
end


def count(view, symbol)
    view.sum{ |row| row.select{ |char| char == symbol }.length }
end


def is_a_monster(section)
    monster = [
        "                  # ",
        "#    ##    ##    ###",
        " #  #  #  #  #  #   "
    ].map(&:chars)

    section.each_with_index{ |row, j|
        row.each_with_index{ |sqr, i|
            return false unless monster[j][i] == " " || sqr == "#" 
        }
    }

    true
end


def get_borders(mosaic)
    [:top, :bottom, :left, :right].map{ |pos| get_border(mosaic, pos) }
end


def get_border(mosaic, pos)
    case pos
    when :top
        return mosaic[0]
    when :bottom
        return mosaic[-1]
    when :right
        return mosaic.map{ |row| row[-1] }
    when :left
        return mosaic.map{ |row| row[0] }
    end
end


def add_border(mosaic, border, pos)
    case pos
    when :top
        return mosaic.unshift(border)
    when :bottom
        return mosaic.push(border)
    when :right
        return mosaic.map.with_index{ |row, i| row.push(border[i]) }
    when :left
        return mosaic.map.with_index{ |row, i| row.unshift(border[i]) }
    end
end


def product_of_corner_keys(mosaic)
    [0, -1].repeated_permutation(2).map{ |i, j| 
        mosaic[i][j].id
    }.inject(:*)
end


images.map!{ |image| Image.new(image) }

mosaic = assemble(images)

puts "Part 1: " + product_of_corner_keys(mosaic).to_s
puts "Part 2: " + waters_roughness(mosaic_to_views(mosaic)).to_s
