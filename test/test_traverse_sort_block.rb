require_relative 'helper'

class TraverseSortBlockTest < Test::Unit::TestCase
  include AST::Sexp
  include GemfileArranger::Testing

  test 'Sort by large categories' do
    # ----
    # gem 'bar'
    # gem 'action_args'
    # source 'https://rubygems.org'
    # ruby '2.1.5'
    # ----
    ast = \
      s(:begin,
        s(:send, nil, :gem,
          s(:str, 'bar')),
        s(:send, nil, :gem,
          s(:str, 'action_args')),
        s(:send, nil, :source,
          s(:str, 'https://rubygems.org')),
        s(:send, nil, :ruby,
          s(:str, '2.1.5')))

    # ----
    # source 'https://rubygems.org'
    # ruby '2.1.5'
    # gem 'bar'
    # gem 'action_args'
    # ----
    ast_expected = \
      s(:begin,
        s(:send, nil, :source,
          s(:str, 'https://rubygems.org')),
        s(:send, nil, :ruby,
          s(:str, '2.1.5')),
        s(:send, nil, :gem,
          s(:str, 'bar')),
        s(:send, nil, :gem,
          s(:str, 'action_args')))

    config = %w(source ruby gemspec gem group)
    sort_block = GemfileArranger::Traverse::SortBlock.new(config)

    assert do
      sort_block.process(ast) == ast_expected
    end
  end

  test 'Equal contents_to_ast' do
    contents = <<-EOS.unindent
      gem 'bar'
      gem 'action_args'
      source 'https://rubygems.org'
      ruby '2.1.5'
    EOS
    ast = \
      s(:begin,
        s(:send, nil, :gem,
          s(:str, 'bar')),
        s(:send, nil, :gem,
          s(:str, 'action_args')),
        s(:send, nil, :source,
          s(:str, 'https://rubygems.org')),
        s(:send, nil, :ruby,
          s(:str, '2.1.5')))

    assert do
      contents_to_ast(contents) == ast
    end
  end

  test 'Sort by large categories with contents' do
    contents = <<-EOS.unindent
      gem 'bar'
      gem 'action_args'
      source 'https://rubygems.org'
      ruby '2.1.5'
    EOS

    expected = <<-EOS.unindent
      source 'https://rubygems.org'
      ruby '2.1.5'
      gem 'bar'
      gem 'action_args'
    EOS

    config = %w(source ruby gemspec gem group)
    sort_block = GemfileArranger::Traverse::SortBlock.new(config)

    assert do
      sort_block.process(contents_to_ast(contents)) == contents_to_ast(expected)
    end
  end
end
