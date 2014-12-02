#!/usr/bin/env ruby
require 'gemfile_arranger'
require 'parser/current'
require 'byebug'
require 'pp'
require 'unparser'

class RemoveDo < Parser::Rewriter
  def on_while(node)
    # Check if the statement starts with "do"
    if node.location.begin.is?('do')
      remove(node.location.begin)
    end
  end
end

class SortBlock < Parser::Rewriter
  def on_send(node)
    super
    if node.children[1] == :gem
      byebug
      insert_before(node.loc.selector, '1')
    end
  end

  def on_begin(node)
    byebug
  end
end

code = <<-EOF
# comment 1
gem 'action_args'
source 'https://rubygems.org'

ruby '2.1.2' # comment 2
EOF

expect = <<-EOF
source 'https://rubygems.org'
ruby '2.1.2'
gem 'action_args'
EOF

buffer        = Parser::Source::Buffer.new('(example)')
buffer.source = code
parser        = Parser::CurrentRuby.new
ast           = parser.parse(buffer)
rewriter      = RemoveDo.new
#
# # Rewrite the AST, returns a String with the new form.
# puts rewriter.rewrite(buffer, ast)

class SourceProcessor < Parser::AST::Processor
  def initialize
  end

  def on_begin(node)
    node.updated(:begin, node.children.sort_by{|child| child.children[1]})
    # nodes = process_all(node)
    # name, args, *body = *node
  end
end

processor = SourceProcessor.new
# pp processor.process(ast)
rewrited_ast = processor.process(ast)
puts Unparser.unparse(rewrited_ast)
# new_buffer = Parser::Source::Buffer.new('(new)')
# puts rewriter.rewrite(new_buffer, rewrited_ast)
# new_source = rewriter.rewrite(new_buffer, rewrited_ast)
# new_buffer.source = new_source
#
# puts new_buffer.source
