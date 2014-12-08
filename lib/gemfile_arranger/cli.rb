require 'gemfile_arranger'
require 'gemfile_arranger/version'
require 'thor'
require 'safe_yaml/load'
require 'unparser'
require 'pathname'
require 'yaml'

module GemfileArranger
  class InitConfig < Thor::Group
    include Thor::Actions
    SHORT_DESCRIPTION = 'Generate a simple .gemfile_arranger.yml, placed in the current directory'

    def self.source_root
      Pathname
        .new(__FILE__)
        .dirname
        .join('templates')
        .expand_path
    end

    def create_gemfile_arranger_yml
      copy_file '.gemfile_arranger.yml'
    end
  end

  class CLI < Thor
    default_task :arrange

    desc 'version', "Print the gemfile_arranger's version information"
    def version
      puts "Gemfile Arranger version #{VERSION}"
    end
    map %w(-v --version) => :version

    desc 'arrange', 'Arrange given Gemfile'
    option :gemfile, default: 'Gemfile', desc: 'The location of the Gemfile(5)'
    option :auto_correct, type: :boolean, aliases: '-a', desc: 'Auto-correct Gemfile(5)'
    def arrange
      code = gemfile_contents(options[:gemfile])

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

      rewrited_gemfile = Unparser.unparse(rewrited_ast)
      if options[:auto_correct]
        rewrite_gemfile(rewrited_gemfile, options[:gemfile])
        puts "Rewrite Gemfile compete! #{options[:gemfile]}"
      else
        puts rewrited_gemfile
      end
    end

    desc 'show-config', 'Print applying configuration'
    def show_config
      puts YAML.dump(config)
    end

    desc 'show-base-config', 'Print original base configuration'
    def show_base_config
      puts YAML.dump(base_config)
    end

    register(InitConfig, 'init', 'init', InitConfig::SHORT_DESCRIPTION)

    private

    def base_config
      base_config_path = file_path
                         .dirname
                         .join('..', '..', 'config', '.gemfile_arranger.base.yml')
                         .expand_path
      fail "Can not read base config: #{base_config_path}" unless base_config_path.file?

      base_config_contents = base_config_path.read
      SafeYAML.load(base_config_contents) || {}
    end

    def user_config
      user_config_path = root_path
                         .join('.gemfile_arranger.yml')
                         .expand_path
      return {} unless user_config_path.file?

      user_config_contents = user_config_path.read
      SafeYAML.load(user_config_contents) || {}
    end

    def config
      base_config.merge(user_config)
    end

    def gemfile_contents(filename)
      gemfile_path = root_path
                     .join(filename)
                     .expand_path
      fail "Can not read Gemfile: #{gemfile_path}" unless gemfile_path.file?
      gemfile_path.read
    end

    def root_path
      Pathname.pwd
    end

    def file_path
      Pathname.new(__FILE__)
    end

    def rewrite_gemfile(contents, filename)
      root_path
        .join(filename)
        .expand_path
        .write(contents + "\n")
    end
  end
end
