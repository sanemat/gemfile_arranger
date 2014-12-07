require_relative 'helper'

class TraverseSorGemsInGroupTest < Test::Unit::TestCase
  include AST::Sexp
  include GemfileArranger::Testing

  test 'Sort gems in group with contents' do
    contents = <<-EOS.unindent
      gem 'bar'
      source 'https://rubygems.org'
      group :development do
        gem 'foo'
        gem 'baz'
      end
      ruby '2.1.5'
    EOS

    expected = <<-EOS.unindent
      gem 'bar'
      source 'https://rubygems.org'
      group :development do
        gem 'baz'
        gem 'foo'
      end
      ruby '2.1.5'
    EOS

    sort_block = GemfileArranger::Traverse::SortGemsInGroup.new

    assert do
      sort_block.process(contents_to_ast(contents)) == contents_to_ast(expected)
    end
  end

  test 'No effect to single gem in group' do
    contents = <<-EOS.unindent
      gem 'bar'
      source 'https://rubygems.org'
      group :development do
        gem 'single'
      end
      ruby '2.1.5'
    EOS

    expected = <<-EOS.unindent
      gem 'bar'
      source 'https://rubygems.org'
      group :development do
        gem 'single'
      end
      ruby '2.1.5'
    EOS

    sort_block = GemfileArranger::Traverse::SortGemsInGroup.new

    assert do
      sort_block.process(contents_to_ast(contents)) == contents_to_ast(expected)
    end
  end
end
