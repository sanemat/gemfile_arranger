require_relative 'helper'

class TestingTest < Test::Unit::TestCase
  include AST::Sexp
  include GemfileArranger::Testing

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
end
