#!/usr/bin/env ruby
require 'gemfile_arranger'
require 'parser/current'
require 'byebug'
require 'pp'
require 'unparser'
require 'safe_yaml/load'

base_config = SafeYAML.load_file('config/.gemfile_arranger.base.yml')

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

class SourceProcessor < Parser::AST::Processor
  def on_begin(node)
    node.updated(:begin, node.children.sort_by{|child| child.children[1]})
    # nodes = process_all(node)
    # name, args, *body = *node
  end
end

processor = SourceProcessor.new
rewrited_ast = processor.process(ast)
puts Unparser.unparse(rewrited_ast)
