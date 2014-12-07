require_relative 'helper'

class TraverseSortBlockTest < Test::Unit::TestCase
  include AST::Sexp

  def contents_to_ast(contents, as_file = true)
    code = (as_file) ? '(' + contents + ')' : contents

    buffer        = Parser::Source::Buffer.new('(contents_to_ast)')
    buffer.source = code
    parser        = Parser::CurrentRuby.new
    parser.parse(buffer)
  end

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
end
