#!/usr/bin/env ruby
require 'gemfile_arranger'

require 'parser/current'

class RemoveDo < Parser::Rewriter
  def on_while(node)
    # Check if the statement starts with "do"
    if node.location.begin.is?('do')
      remove(node.location.begin)
    end
  end
end

code = <<-EOF
while true do
  puts 'hello'
end
EOF

buffer        = Parser::Source::Buffer.new('(example)')
buffer.source = code
parser        = Parser::CurrentRuby.new
ast           = parser.parse(buffer)
rewriter      = RemoveDo.new

# Rewrite the AST, returns a String with the new form.
puts rewriter.rewrite(buffer, ast)
