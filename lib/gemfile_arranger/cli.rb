require 'gemfile_arranger'
require 'gemfile_arranger/version'
require 'thor'
require 'safe_yaml/load'
require 'unparser'

module GemfileArranger
  class CLI < Thor
    default_task :arrange

    desc 'version', "Prints the gemfile_arranger's version information"
    def version
      puts "Gemfile Arranger version #{VERSION}"
    end
    map %w(-v --version) => :version

    desc '', 'arrange arrange arrange'
    option :gemfile
    def arrange
      base_config = SafeYAML.load_file('config/.gemfile_arranger.base.yml')
      config = base_config

      if options[:gemfile] && File.file?(options[:gemfile])
        code = File.read(options[:gemfile])
      else
        fail 'Not implement.'
      end

      buffer        = Parser::Source::Buffer.new('(gemfile_arranger arrange)')
      buffer.source = code
      parser        = Parser::CurrentRuby.new
      ast           = parser.parse(buffer)

      sort_gems_in_group = Traverse::SortGemsInGroup.new
      rewrited_ast = sort_gems_in_group.process(ast)

      sort_priority_gems_in_group = Traverse::SortPriorityGemsInGroup.new(config['priority_gem'])
      rewrited_ast = sort_priority_gems_in_group.process(rewrited_ast)

      sort_block = Traverse::SortBlock.new(config['block_order'])
      rewrited_ast = sort_block.process(rewrited_ast)

      puts Unparser.unparse(rewrited_ast)
    end

    desc 'init', 'Initialize configuration'
    def init

    end
  end
end
