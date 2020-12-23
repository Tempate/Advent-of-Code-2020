file = File.open("input.txt")
input = file.readlines.map(&:chomp)


def parse(input)
    input.map{ |recipe|
        parts = recipe.match(/(?<ingredients>(\w|\s)+) \(contains (?<allergens>(\w|\s|,)+)\)/)
        {
            :ingredients => parts[:ingredients].split(),
            :allergens => parts[:allergens].split(", ")
        }
    }
end


def allergens_for_ingredients(recipes, ingredients)
    allergens = elements_in_recipes(recipes, :allergens)
    allergens_to_ingredients = ingredients_for_allergens(recipes, allergens)

    ingredients.map{ |ingredient|
        [
            ingredient, 
            allergens.select{ |allergen| 
                allergens_to_ingredients[allergen].include? ingredient 
            }
        ]
    }.to_h
end


def ingredients_for_allergens(recipes, allergens)
    allergens.map{ |allergen|
        [allergen, ingredients_for_allergen(recipes, allergen)]
    }.to_h
end


def ingredients_for_allergen(recipes, allergen)
    recipes.map{ |recipe|
        recipe[:ingredients] if recipe[:allergens].include? allergen
    }.compact.inject(:&)
end


def safe_ingredients(recipes)
    ingredients = elements_in_recipes(recipes, :ingredients)
    ingredients_to_allergens = allergens_for_ingredients(recipes, ingredients)

    ingredients.select{ |ingredient|
        ingredients_to_allergens[ingredient].length == 0
    }
end


def dangerous_ingredient_list(recipes)    
    ingredients = elements_in_recipes(recipes, :ingredients)
    ingredients_to_allergens = allergens_for_ingredients(recipes, ingredients)

    dangerous_ingredients = ingredients.reject{ |ingredient|
        ingredients_to_allergens[ingredient].length == 0
    }

    dangerous_ingredients_to_allergens = dangerous_ingredients.map{ |ingredient|
        [ingredient, ingredients_to_allergens[ingredient]]
    }.to_h

    dangerous_ingredients_to_allergen = Hash.new

    while dangerous_ingredients_to_allergen.length < dangerous_ingredients_to_allergens.length
        dangerous_ingredients_to_allergens.each{ |ingredient, allergens|
           dangerous_ingredients_to_allergen[ingredient] = allergens[0] if allergens.length == 1
        }

        dangerous_ingredients_to_allergens.each{ |ingredient, allergens|
            dangerous_ingredients_to_allergens[ingredient] -= dangerous_ingredients_to_allergen.values
        }.to_h
    end

    dangerous_ingredients.sort_by{ |ingredient|
        dangerous_ingredients_to_allergen[ingredient]
    }.join(",")
end


def elements_in_recipes(recipes, type)
    recipes.map{ |recipe| recipe[type] }.flatten.uniq
end


def count_appearances(recipes, ingredient)
    recipes.select{ |recipe| recipe[:ingredients].include? ingredient }.length
end


recipes = parse(input)
safe = safe_ingredients(recipes)

puts "Part 1: " + safe.sum{ |ingredient| count_appearances(recipes, ingredient)}.to_s
puts "Part 2: " + dangerous_ingredient_list(recipes).to_s
