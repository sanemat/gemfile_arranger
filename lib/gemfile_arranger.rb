require 'gemfile_arranger/version'
require 'parser/current'
require 'unparser'

module GemfileArranger
  class Base
    def self.parse(code)
      ast, comments = Parser::CurrentRuby.parse_with_comments(code)
      [ast, comments]
    end

    def self.traverse(ast)
      ast
    end

    def self.generate(ast, comments = nil)
      Unparser.unparse(ast, comments)
    end
  end
end
