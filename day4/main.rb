file = File.open("input.txt")
$people = file.read.split("\n\n")


ID = {
    "byr" => 0b00000001, 
    "iyr" => 0b00000010, 
    "eyr" => 0b00000100, 
    "hgt" => 0b00001000,
    "hcl" => 0b00010000, 
    "ecl" => 0b00100000, 
    "pid" => 0b01000000, 
    "cid" => 0b10000000
}

COMPLETE_CHECKLIST = 0b11111111

# The only verification required is the field being there
def policy1(*_)
    return true
end

# Each field needs to be verified individually
def policy2(label, content)
    in_range = lambda {|value, min, max| value >= min && value <= max}

    case label
    when "byr"
        return in_range.call(content.to_i, 1920, 2002)
    when "iyr"
        return in_range.call(content.to_i, 2010, 2020)
    when "eyr"
        return in_range.call(content.to_i, 2020, 2030)
    when "hgt"
        units = content[-2..-1]
        value = content[0..-3].to_i

        case units
        when "cm"
            return in_range.call(value, 150, 193)
        when "in"
            return in_range.call(value, 59, 76)
        end
    when "hcl"
        return content =~ /^#(\d|[a-f]){6}$/
    when "ecl"
        return content =~ /^(amb|blu|brn|gry|grn|hzl|oth)$/
    when "pid"
        return content =~ /^\d{9}$/
    end
end


def count_valid_passports(policy)
    valid = 0

    $people.each do |person|
        fields = person.split(' ')

        # Less than 7 fields can't complete the checklist
        if fields.length() < 7
            next
        end

        checklist = 0

        fields.each do |field|
            label, content = field.split(':')

            if method(policy).call(label, content)
                checklist |= ID[label]
            end
        end

        checklist |= ID["cid"]

        if checklist == COMPLETE_CHECKLIST
            valid += 1
        end
    end

    return valid
end


puts "Part 1: " + count_valid_passports(:policy1).to_s
puts "Part 2: " + count_valid_passports(:policy2).to_s
