file = File.open("input.txt")
$lines = file.readlines.map(&:chomp)


def parse_input()
    bags = {}

    entry_pattern = Regexp.compile('^(.+) bags contain (.+)\.$')
    items_pattern = Regexp.compile('^(\d+) (.+) (bag|bags)$')

    $lines.each do |line|
        name, items = entry_pattern.match(line)[1..2]

        bags[name] = []

        if items == "no other bags"
            next
        end

        items.split(", ").each do |item|
            info = items_pattern.match(item)

            bags[name].push({
                "amount" => info[1].to_i,
                "type"   => info[2]
            })
        end
    end

    return bags
end


def bag_contains_package(bag, package)
    $bags[bag].any? { |sub_bag|
        sub_bag["type"] == package || bag_contains_package(sub_bag["type"], package)
    }
end


def count_bags_that_contain_package(package)
    $bags.keys().select { |bag| bag_contains_package(bag, package) }.length()
end


def count_packages_for_bag(bag)
    $bags[bag].sum { |bag_info|
        bag_info["amount"] * (count_packages_for_bag(bag_info["type"]) + 1)
    }
end


$bags = parse_input()

puts "Part 1: " + count_bags_that_contain_package("shiny gold").to_s
puts "Part 2: " + count_packages_for_bag("shiny gold").to_s
