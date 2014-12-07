require 'gemfile_arranger'
require 'gemfile_arranger/version'
require 'thor'

module GemfileArranger
  class CLI < Thor
    desc "version", "Prints the gemfile_arranger's version information"
    def version
      puts "Gemfile Arranger version #{GemfileArranger::VERSION}"
    end
    map %w(-v --version) => :version
  end
end
