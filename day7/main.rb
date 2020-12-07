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
    $bags[bag].each do |sub_bag|
        if sub_bag["type"] == package || bag_contains_package(sub_bag["type"], package)
            return true
        end
    end

    return false
end


def count_bags_that_contain_package(package)
    count = 0

    $bags.keys().each do |bag|
        if bag_contains_package(bag, package)
            count += 1
        end
    end

    return count
end


def count_packages_for_bag(bag)
    count = 0
    
    $bags[bag].each do |bag_info|
        count += bag_info["amount"] * (count_packages_for_bag(bag_info["type"]) + 1)
    end

    return count
end


$bags = parse_input()

puts "Part 1: " + count_bags_that_contain_package("shiny gold").to_s
puts "Part 2: " + count_packages_for_bag("shiny gold").to_s
