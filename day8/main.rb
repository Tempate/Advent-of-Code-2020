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


def fix_wrong_opcode(program, wrong_opcodes)
    program.each_with_index do |line, index|
        opcode, value = line.split(" ")

        case opcode
        when wrong_opcodes[0]
            new_program = program_copy_changing_line(program, index, wrong_opcodes[1], value)
        when wrong_opcodes[1]
            new_program = program_copy_changing_line(program, index, wrong_opcodes[0], value)
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


def program_copy_changing_line(program, index, opcode, value)
    new_program = Marshal.load(Marshal.dump(program))
    new_program[index] = opcode + " " + value
    return new_program
end


puts "Part 1: " + run_code($program)[1].to_s
puts "Part 2: " + fix_wrong_opcode($program, ["nop", "jmp"]).to_s
