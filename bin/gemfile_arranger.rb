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
gem 'bar'
gemspec

group :development do
  gem 'bullet'
end

gem 'foo'
gem 'abba'

platforms :ruby do
  gem 'mami'
end

group :test do
  gem 'database_rewinder'
  gem 'capybara-webkit'
  gem 'redis'
end

ruby '2.1.2' # comment 2
EOF

expect = <<-EOF
source 'https://rubygems.org'
ruby '2.1.2'
gemspec
gem 'abba'
gem 'action_args'
gem 'bar'
gem 'foo'
group :development do
  gem 'bullet'
end

group :test do
  gem 'redis'
  gem 'capybara-webkit'
  gem 'database_rewinder'
end

platforms :ruby do
  gem 'mami'
end
EOF

buffer        = Parser::Source::Buffer.new('(example)')
buffer.source = code
parser        = Parser::CurrentRuby.new
ast           = parser.parse(buffer)

class SortPriorityGemInGroupTraverser < Parser::AST::Processor
  def initialize(keys)
    @keys = Array(keys.dup).map(&:to_s)
  end

  def on_block(node)
    sorted_block = sort_gem_in_group_with_keys(node, @keys)
    node.updated(:block, sorted_block) if node != sorted_block
  end

  def sort_gem_in_group_with_keys(node, keys)
    send_node, args_node, body_node = node.children
    return node if send_node.children[1] != :group
    return node if body_node.type != :begin
    gems = body_node.children.sort_by.with_index do |child, i|
      gem_name = child.children[2].children[0]
      key_index = keys.index(gem_name) || keys.length
      [key_index, i]
    end
    return node if body_node.children == gems

    sorted_body_node = body_node.updated(:begin, gems)
    [send_node, args_node, sorted_body_node]
  end
end

sort_gems_in_group = GemfileArranger::SortGemsInGroupTraverser.new
rewrited_ast = sort_gems_in_group.process(ast)

sort_priority_gem_in_group = SortPriorityGemInGroupTraverser.new(CONFIG['priority_gem'])
rewrited_ast = sort_priority_gem_in_group.process(rewrited_ast)

sort_block = GemfileArranger::SortBlockTraverser.new(CONFIG['block_order'])
rewrited_ast = sort_block.process(rewrited_ast)

puts Unparser.unparse(rewrited_ast)
