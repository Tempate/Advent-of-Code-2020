file = File.open("input.txt")

homework1 = file.readlines.map(&:chomp).map{ |expr| expr.chars.grep_v(/\s/) }
homework2 = Marshal.load(Marshal.dump(homework1))


def remove_parenthesis(expr, precedence = false)

    while expr.include? "("
        # We find the index of the last ( and of the following ),
        # operate the result and replace it in the expression 

        par0 = expr.rindex("(")
        par1 = par0 + expr[par0..].index(")")

        result = operate(expr[par0 + 1..par1 - 1], precedence)

        expr[par0..par1] = [result]
    end

    expr
end


def operate(expr, precedence = false, operator = "+")
    expr = remove_parenthesis(expr, precedence)

    if precedence
        expr = execute_operation(expr, operator)    
    end

    # Exhaust all operations in linear order

    result = expr.shift.to_i

    until expr.empty?
        operator, number = expr.shift(2)

        result = calculate(result, number.to_i, operator)
    end

    result
end


def execute_operation(expr, operator)
    # Exhaust all operations for a given operator

    while expr.include? operator
        index = expr.index(operator)

        m = expr[index-1].to_i
        n = expr[index+1].to_i

        # Replace operation with its result
        expr[index-1..index+1] = [calculate(m, n, operator)]
    end

    expr
end


def calculate(m, n, operation)
    m.public_send operation, n
end


puts "Part 1: " + homework1.sum{ |expr| operate(expr, false) }.to_s
puts "Part 2: " + homework2.sum{ |expr| operate(expr, true) }.to_s
