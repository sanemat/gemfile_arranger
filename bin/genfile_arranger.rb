#!/usr/bin/env ruby
require 'gemfile_arranger'

code = ARGF.read
ast, comments = GemfileArranger::Base.parse(code)
generated = GemfileArranger::Base.generate(ast, comments)
puts ast.inspect
puts generated
