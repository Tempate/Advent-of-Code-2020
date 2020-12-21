class Chain
    attr_reader :rules
    
    def initialize(str)
        @rules = str.split.map(&:to_i)
    end

    def length
        @rules.length
    end

    def can_be_simplified
        @rules.any? { |rule|
            case rule
            when Integer
                true
            when Chain
                rule.can_be_simplified
            end
        }
    end

    def simplify(rules)
        if self.can_be_simplified
            @rules.map!{ |rule|
                case rule
                when Integer
                    rules[rule]
                when Chain
                    rule.simplify(rules)
                    rule
                end
            }
        end
    end

    def get_rules
        Marshal.load(Marshal.dump(@rules))
    end

    def to_s
        "(" + @rules.map(&:to_s).join(", ") + ")"
    end
end


class OrChain < Chain
    def initialize(str)
        @rules = str.split(" | ").map{ |substr| Chain.new(substr) }
    end

    def to_s
        "[" + @rules.map(&:to_s).join(", ") + "]"
    end
end