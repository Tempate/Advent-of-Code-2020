file = File.open("input.txt")
$operations = file.readlines.map(&:chomp)


MASK_PATTERN = Regexp.compile(/^mask = (?<mask>(X|0|1){36})$/)
MEMORY_PATTERN = Regexp.compile(/^mem\[(?<address>\d+)\] = (?<value>\d+)$/)


BYTE_LENGTH = 36


def run_program(address_policy, value_policy)
    memory = {}

    mask = ''

    $operations.each do |operation|
        if data = operation.match(MASK_PATTERN)
            mask = data[:mask]
        
        elsif data = operation.match(MEMORY_PATTERN)

            method(address_policy).call(data[:address].to_i, mask).each { |address|
                memory[address] = method(value_policy).call(data[:value], mask)
            }
        end
    end

    return memory
end


def value_policy1(value, mask)
    mask0 = 0
    mask1 = 0

    mask.each_char do |char|
        mask0 <<= 1
        mask1 <<= 1

        case char
        when '1'
            mask0 |= 1
            mask1 |= 1
        when 'X'
            mask0 |= 1
        end
    end

    return (value.to_i & mask0) | mask1
end


def value_policy2(value, mask)
    return value.to_i
end


def address_policy1(address, mask)
    return [address.to_i]
end


def address_policy2(address, mask)
    address = address.to_s(2).rjust(BYTE_LENGTH, '0')

    return generate_masks(mask, address).map{ |mask_| mask_.to_i(2) }
end


def generate_masks(mask, value)
    return [''] if mask == nil || mask == ''

    submasks = generate_masks(mask[1..-1], value[1..-1])

    case (mask[0])
    when '0'
        return submasks.map{ |mask_| value[0] + mask_ }
    when '1'
        return submasks.map{ |mask_| '1' + mask_ }
    when 'X'
        return submasks.map{ |mask_| ['0' + mask_, '1' + mask_] }.flatten
    end
end


puts "Part 1: " + run_program(:address_policy1, :value_policy1).values.inject(:+).to_s
puts "Part 2: " + run_program(:address_policy2, :value_policy2).values.inject(:+).to_s
