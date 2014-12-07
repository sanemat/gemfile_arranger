module GemfileArranger
  module Testing
    # NOTE: Too slow(140X slower).
    #       0.00487 seconds(ast vs ast) vs 0.678528 seconds(contents vs contents)
    def contents_to_ast(contents)
      buffer        = Parser::Source::Buffer.new('(contents_to_ast)')
      buffer.source = contents
      parser        = Parser::CurrentRuby.new
      parser.parse(buffer)
    end
  end
end
