#!/usr/bin/env ruby
require 'gemfile_arranger'
require 'parser/current'
require 'byebug'
require 'pp'
require 'unparser'
require 'safe_yaml/load'

base_config = SafeYAML.load_file('config/.gemfile_arranger.base.yml')
CONFIG = base_config

code = <<-EOF
# comment 1
gem 'action_args'
source 'https://rubygems.org'
gem 'foo'
gem 'bar'

group :development do
  gem 'bullet'
end

group :test do
  gem 'database_rewinder'
  gem 'capybara-webkit'
end

ruby '2.1.2' # comment 2
EOF

expect = <<-EOF
source 'https://rubygems.org'
ruby '2.1.2'
gem 'action_args'
gem 'bar'
gem 'foo'
group :development do
  gem 'bullet'
end

group :test do
  gem 'capybara-webkit'
  gem 'database_rewinder'
end
EOF

buffer        = Parser::Source::Buffer.new('(example)')
buffer.source = code
parser        = Parser::CurrentRuby.new
ast           = parser.parse(buffer)

class SortBlockTraverser < Parser::AST::Processor
  def on_begin(node)
    sorted_block = sort_block_with_keys(node, keys)
    node.updated(:begin, sorted_block)
  end

  def keys
    Array(CONFIG['block_order'].dup).map(&:to_sym)
  end

  def sort_block_with_keys(node, keys)
    node.children.sort_by.with_index do |child, i|
      _, args, *_ = child.children
      key_index = keys.index(args) || keys.lengh
      [key_index, i]
    end
  end
end

processor = SortBlockTraverser.new
rewrited_ast = processor.process(ast)
puts Unparser.unparse(rewrited_ast)
