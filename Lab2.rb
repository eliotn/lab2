# Part1: Hello World
class HelloWorldClass
    def initialize(name)
       @name = name.capitalize
    end
    def sayHi
        puts "Hello #{@name}!"
    end
end
hello = HelloWorldClass.new("eliot")
hello.sayHi

#count_regex returns a hash with each match to the regex and the number of occurances
class String
  def count_regex(regex)
    regexmatches = self.scan(regex)
    counts = Hash.new(0);
    regexmatches.each{ |match| counts[match] += 1 }
    counts
  end
  #source for gsub - http://stackoverflow.com/questions/7512160/simple-way-for-removing-all-non-word-characters
  #the gsub replaces nonword or number characters with ""
  def palindrome?
    string = self.downcase.gsub(/[\W\d]+/,"")
    string.reverse.eql?(string)
  end

end

module Enumerable
  def palindrome?
    self.reverse.eql?(self)
  end
end

def count_words(string)
  words = string.downcase.count_regex(/\w+/)
end

class WrongNumberOfPlayersError <  StandardError; end
class NoSuchStrategyError <  StandardError; end

def rps_game_winner(game)
  rpsmoves = ["R", "P", "S"]
  player2wins = [["R", "P"], ["P", "S"], ["S", "R"]]
  raise WrongNumberOfPlayersError unless game.length == 2
  raise NoSuchStrategyError unless rpsmoves.include?(game[0][1]) and rpsmoves.include?(game[1][1])
  if player2wins.include?([game[0][1],game[1][1]])
    game[1]
  else
    game[0]
  end
end

def rps_tournament_winner(gameseries)
  if gameseries[0][0].is_a?(String)
    rps_game_winner(gameseries)
  else
    rps_game_winner([rps_tournament_winner(gameseries[0]),rps_tournament_winner(gameseries[1])])
  end
end

#find all letter combinations, then map each word to a unique index in an array based on each unique letter combination
#finally create the array with each valid subarray
def combine_anagrams(strings)
  lettercombinations = strings.map{|string| string.count_regex(/\w/)}
  lettercombinationsunique = lettercombinations.uniq
  lettercombinationsindex = lettercombinations.map{|lettercombination| lettercombinationsunique.index(lettercombination)}
  newarray = lettercombinationsunique.map{[]}#pitfall, new will make the same copy of the array throughout
  strings.each_index{|i| newarray[lettercombinationsindex[i]].push(strings[i])}
  newarray
end

class Dessert
  def initialize(name, calories)
    @name = name
    @calories = calories
  end
  #these provide name and name= methods that directly set and get values
  attr_accessor :name
  attr_accessor :calories
  def healthy?
    calories < 200
  end
  def delicious?
    true
  end
end

class JellyBean < Dessert
  def initialize(name, calories, flavor)
    super(name, calories)
    @flavor = flavor
  end
  attr_accessor :flavor
  def delicious?
    flavor != 'black licorice'
  end
end

#does attr_accessor with history
#gets each argument with input, then creates getters for the argument and argument_history
#argument_history starts at [nil] and automatically gets new arguments concatinated when argument is changed
#argument is defined by the name attached to the attr_accessor
#thanks: http://mikeyhogarth.wordpress.com/2011/12/01/creating-your-own-attr_accessor-in-ruby/
class Class
  def attr_accessor_with_history(*args)
    args.each do |arg|
      self.class_eval("def #{arg}_history; @#{arg}_history; end;")
      self.class_eval("def #{arg}; @#{arg}; end;")
      self.class_eval("def #{arg}=(var); @#{arg} = var; @#{arg}_history = @#{arg}_history + [var]; end;")
      self.class_eval("def initialize; @#{arg} = nil; @#{arg}_history = [nil]; end;")
    end
  end
end


class Numeric
 @@currencies = {'dollar' => 1, 'yen' => 0.013, 'euro' => 1.292, 'rupee' => 0.019}
  def method_missing(method_id)
   singular_currency = method_id.to_s.gsub( /s$/, '')
   if @@currencies.has_key?(singular_currency)
     self * @@currencies[singular_currency]
   else
     super
   end
 end
  #get the inverse of the currency value
  def in(function)
    eval("firstresult = 1.#{function}; self/firstresult")
  end
end

#makes an array with the cross producted elements, and does an each on the block
class CartesianProduct
  include Enumerable
  def initialize(part1, part2)
    @self = []
    part1.each{|elem1| part2.each{ |elem2| @self.push([elem1, elem2])}};
  end
  def each(&block)
    @self.each(&block)
  end
end




puts "Palindrome tests: should be true, true, false";
puts "A man, a plan, a canal -- Panama".palindrome?;
puts "Madam, I'm Adam!".palindrome?;
puts "Abracadabra".palindrome?;
puts "Count words tests:";
puts count_words("A man, a plan, a canal -- Panama");
puts count_words("Doo bee doo bee doo");
puts "RPS tests:";
begin
  puts rps_game_winner(["WRONG Number"]);
rescue WrongNumberOfPlayersError
  puts "Wrong number of players caught!";
end
begin
  puts rps_game_winner([["p1", "P"],["p2", "NOPE"]]);
rescue NoSuchStrategyError
  puts "Invalid move caught!";
end
puts rps_game_winner([["Armando", "P"], ["Dave", "S"]]).to_s;
puts rps_game_winner([["Armando", "S"], ["Dave", "S"]]).to_s;
puts "RPS Tournament tests:";
puts rps_tournament_winner([[[["Armando", "P"], ["Dave", "S"]],
    [["Richard", "R"], ["Michael", "S"]]],
    [[["Allen", "S"], ["Omer", "P"]],
    [["David E.", "R"], ["Richard X.", "P"]]]]).to_s;
puts "Anagram combination test:"
puts combine_anagrams(['cars', 'for', 'potatoes', 'racs', 'four', 'scar', 'creams', 'scream']).to_s;
puts "Classes tests:";
des = Dessert.new("Delete me", 0);
des.name = "1 calorie dessert";
des.calories = 1;
puts des.name + " has " + des.calories.to_s + " calories!";
puts "Delicious: " + des.delicious?.to_s + " Healthy: " + des.healthy?.to_s;
des2 = JellyBean.new("Delete me", 0, "nothing");
puts des2.flavor + " is Delicious? " + des2.delicious?.to_s;
des2.name = "Black Licorice";
des2.flavor = "black licorice";
puts des2.name + " is Delicious? " + des2.delicious?.to_s
puts "attr_accessor tests";
class Foo
  attr_accessor_with_history :bar
end
f = Foo.new;
f.bar = 3;
f.bar = :wowzo;
f.bar = 'boo';
puts f.bar_history.to_s;
f = Foo.new;
puts f.bar_history.to_s;
f.bar = 1;
f.bar = 2;
puts f.bar_history.to_s;
puts "Currency Conversion"
puts 5.dollars.in(:euros);
puts 10.euros.in(:rupees);
puts 1.dollar.in(:rupees);
puts 10.rupees.in(:euro);
puts 10.euros.in(:dollars);
puts "Enumerable palindrome"
puts [1, 2, 3, 2, 1].palindrome?
puts "Cartesian Product"
c = CartesianProduct.new([:a, :b], [4, 5])
c.each{ |elt| puts elt.inspect}
c = CartesianProduct.new([:a, :b], [])
#note this prints nothing because second array is empty
puts "Nothing should be printed for this test case:"
c.each{ |elt| puts elt.inspect}
