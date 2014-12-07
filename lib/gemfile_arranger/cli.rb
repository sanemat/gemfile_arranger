require 'gemfile_arranger'
require 'gemfile_arranger/version'
require 'thor'
require 'safe_yaml/load'
require 'unparser'

module GemfileArranger
  class InitConfig < Thor::Group
    include Thor::Actions
    SHORT_DESCRIPTION = 'Generate a simple .gemfile_arranger.yml, placed in the current directory'

    def self.source_root
      File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
    end

    def create_gemfile_arranger_yml
      copy_file '.gemfile_arranger.yml'
    end
  end

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
      base_config_path = File.expand_path(
        File.join(File.dirname(__FILE__), '..', '..', 'config',  '.gemfile_arranger.base.yml')
      )
      base_config = SafeYAML.load_file(base_config_path)

      require 'pathname'
      root_path = Pathname.new Dir.pwd
      user_config_path = root_path.join('.gemfile_arranger.yml')
      user_config = (File.file?(user_config_path)) \
                    ? SafeYAML.load_file(user_config_path)
                    : {}

      config = base_config.merge(user_config)

      gemfile_path = (options[:gemfile]) \
                     ? root_path.join(options[:gemfile])
                     : root_path.join('Gemfile')
      code = File.read(gemfile_path) if File.file?(gemfile_path)
      fail("Can not read Gemfile: #{gemfile_path}") if code.nil?

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

    register(InitConfig, 'init', 'init', InitConfig::SHORT_DESCRIPTION)
  end
end
