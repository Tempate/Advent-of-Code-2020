require_relative "chains"


file = File.open("input.txt")
rules, messages = file.read.split("\n\n").map{ |part| part.split("\n") }


def parse(rules)
    new_rules = Array.new(rules.length())

    rules.each do |rule|
        id, contents = rule.split(": ")
        
        if contents.include? "\""
            new_rules[id.to_i] = contents[1]
        elsif contents.include? "|"
            new_rules[id.to_i] = OrChain.new(contents)
        else
            new_rules[id.to_i] = Chain.new(contents)
        end
    end

    new_rules
end


def can_be_simplified(rules)
    rules.any? { |rule| rule.can_be_simplified() if rule.is_a? Chain }
end


def simplify(rules)

    while can_be_simplified(rules)
        rules.each{ |rule|
            rule.simplify(rules) if rule.is_a? Chain
        }
    end

    rules
end


def messages_valid_for_rule(messages, rule)
    messages.select{ |message|
        msg = is_message_valid(message, Marshal.load(Marshal.dump(rule)));
        msg && msg.length == 0
    }.length
end


def is_message_valid(message, rules)
    puts message
    puts rules.to_s

    if rules.length() == 0
        return message
    end

    rule = rules.shift()

    case rule
    when String
        if rule == message[0]
            return is_message_valid(message[1..], rules)
        end
    when OrChain
        rule.rules.each{ |subrule|
            submessage = is_message_valid(message, subrule)

            if submessage
                return is_message_valid(submessage, rules)
            end
        }
    when Chain
        rule.rules.each{ |subrule|
            message = is_message_valid(message, subrule)
            
            return false unless message
        }

        return message
    end

    false
end

rules = simplify(parse(rules))

puts "Part 1: " + messages_valid_for_rule(messages, rules[0]).to_s
