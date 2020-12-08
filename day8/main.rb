file = File.open("input.txt")
$program = file.readlines.map(&:chomp)


def run_code(program)
    accumulator = 0
    instruction_register = 0
    history = []

    while !(history.include?(instruction_register)) do
        op_code, value = program[instruction_register].split(" ")

        history.push(instruction_register)

        case op_code
        when "nop"
            instruction_register += 1
        when "acc"
            accumulator += value.to_i
            instruction_register += 1
        when "jmp"
            instruction_register += value.to_i
        end

        if instruction_register >= program.length()
            return false, accumulator
        end
    end

    return true, accumulator
end


def fix_wrong_opcode(program, opcode1, opcode2)
    program.each_with_index do |line, index|
        opcode, value = line.split(" ")

        new_program = Marshal.load(Marshal.dump(program))

        case opcode
        when opcode1
            new_program[index] = opcode2 + " " + value
        when opcode2
            new_program[index] = opcode1 + " " + value
        else
            next
        end

        is_loop, accumulator = run_code(new_program)

        unless is_loop
            return accumulator
        end
    end

    return 0
end


puts "Part 1: " + run_code($program)[1].to_s
puts "Part 2: " + fix_wrong_opcode($program, "nop", "jmp").to_s
