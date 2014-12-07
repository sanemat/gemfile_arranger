module GemfileArranger
  module Testing
    def contents_to_ast(contents)
      buffer        = Parser::Source::Buffer.new('(contents_to_ast)')
      buffer.source = contents
      parser        = Parser::CurrentRuby.new
      parser.parse(buffer)
    end
  end
end
