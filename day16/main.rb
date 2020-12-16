file = File.open("input.txt")
$input = file.read.split("\n\n")


RULE_PATTERN = Regexp.compile(/^(?<name>(\w|\s)+): (?<min1>\d+)-(?<max1>\d+) or (?<min2>\d+)-(?<max2>\d+)$/)


def parse(input)
    rules = input[0].split("\n").map{ |rule| RULE_PATTERN.match(rule)}.map{ |rule| 
        [rule[:name], [ 
            (rule[:min1].to_i..rule[:max1].to_i),
            (rule[:min2].to_i..rule[:max2].to_i)
        ]]
        }.to_h

    ticket = input[1].split("\n")[1].split(",").map(&:to_i)

    tickets = input[2].split("\n")[1..-1].map{ |ticket|
        ticket.split(",").map(&:to_i)
    }

    return rules, ticket, tickets
end


def calculate_ticket_scanning_error_rate(rules, tickets)
    return tickets.sum{ |ticket| is_ticket_valid(rules, ticket)[1] }
end


def find_index_of_rules(rules, tickets)
    valid_tickets = tickets.map{ |ticket| 
        ticket if is_ticket_valid(rules, ticket)[0] 
    }.compact

    # Get all the valid rules for every index
    valid_rules_for_index = tickets[0].map.with_index do |field, index|
        rules.map{ |name, ranges| 
            name if is_rule_valid(valid_tickets, ranges, index) 
        }.compact
    end

    simplify_rules(valid_rules_for_index)
end


def simplify_rules(rules)
    # Gets the forced position of every rule
    new_rules = Array.new(rules.length(), 0)

    while new_rules.include? 0

        # Find the rules that can only be in one place
        fixed_rules = rules.map.with_index { |rule, index|
            [rule[0], index] if rule.length() == 1
        }.compact.to_h

        # Delete fixed rules from the original rules
        rules.map!{ |rule| 
            rule.delete_if{ |rule_| fixed_rules.keys.include? rule_ }
        }

        # Save the fixed rules
        fixed_rules.each { |rule, index| new_rules[index] = rule }
    end

    new_rules
end


def product_of_departures(indexed_rules, ticket)
    return indexed_rules.map.with_index{ |name, index| 
        ticket[index] if name.include? "departure" 
    }.compact.inject(:*)
end


def is_rule_valid(tickets, ranges, label)
    tickets.all? { |ticket| field_in_ranges(ticket[label], ranges) }
end


def is_ticket_valid(rules, ticket)
    ticket.each { |field|
        return false, field unless is_field_valid(rules, field)
    }

    return true, 0
end


def is_field_valid(rules, field)
    rules.any? { |name, ranges| field_in_ranges(field, ranges) }
end


def field_in_ranges(field, ranges)
    ranges.any? { |range| range.cover? field }
end


rules, ticket, tickets = parse($input)


puts "Part 1: " + calculate_ticket_scanning_error_rate(rules, tickets).to_s
puts "Part 2: " + product_of_departures(find_index_of_rules(rules, tickets), ticket).to_s