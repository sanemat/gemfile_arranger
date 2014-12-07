require_relative 'helper'

class TraverseSorPriorityGemsInGroupTest < Test::Unit::TestCase
  include AST::Sexp
  include GemfileArranger::Testing

  test 'Sort priority gems in group with contents' do
    contents = <<-EOS.unindent
      gem 'bar'
      source 'https://rubygems.org'
      group :development do
        gem 'foo'
        gem 'priority-2nd'
        gem 'priority-1st'
        gem 'baz'
      end
      ruby '2.1.5'
    EOS

    expected = <<-EOS.unindent
      gem 'bar'
      source 'https://rubygems.org'
      group :development do
        gem 'priority-1st'
        gem 'priority-2nd'
        gem 'foo'
        gem 'baz'
      end
      ruby '2.1.5'
    EOS
    config = %w(priority-1st priority-2nd)

    sort_block = GemfileArranger::Traverse::SortPriorityGemsInGroup.new(config)

    assert do
      sort_block.process(contents_to_ast(contents)) == contents_to_ast(expected)
    end
  end
end
