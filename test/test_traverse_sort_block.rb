require_relative 'helper'

class TraverseSortBlockTest < Test::Unit::TestCase
  include AST::Sexp

  def test_power_assert
    assert do
      "0".class == "3".to_i.times.map {|i| i + 1 }.class
    end
  end
end
