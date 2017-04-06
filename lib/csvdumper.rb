require "csvdumper/version"
require "csvdumper/row_parser"
require "csvdumper/importer"

module Csvdumper

  if defined?(Rails::Railtie)
    class Railtie < Rails::Railtie
      rake_tasks do
        load File.expand_path('../tasks/import.rake', __FILE__)
      end
    end
  end
end
