class Chain
    attr_reader :rules
    
    def initialize(str)
        @rules = str.split().map(&:to_i)
    end

    def can_be_simplified()
        @rules.any? { |rule|
            case rule
            when Integer
                true
            when String
                false
            when Chain
                rule.can_be_simplified()
            end
        }
    end

    def simplify(rules)
        @rules.map!{ |rule|
            case rule
            when Integer
                rules[rule]
            when Chain
                rule.simplify(rules)
            end
        }
    end
end


class OrChain < Chain
    def initialize(str)
        @rules = str.split(" | ").map{ |substr| Chain(substr) }
    end
end