require 'spec_helper'
require 'generator_spec'
require 'generators/csvdumper/install_generator'
require 'rails'
require 'active_record'
require 'pry'

describe Csvdumper::Generators::InstallGenerator, type: :generator do
  destination File.expand_path("../../tmp", __FILE__)

  class Csvdumper::Generators::InstallGenerator
    def self.next_migration_number(*args)
      '111'
    end
  end

  before(:all) do
    prepare_destination
    run_generator
  end

  it 'should create IpLocation model file' do
    assert_file 'app/models/csvdumper/ip_location.rb', /Csvdumper\:\:IpLocation/
  end

  it 'should create migration' do
    assert_file 'db/migrate/111_csvdumper_create_ip_locations.rb', /create_table \:csvdumper_ip_locations/
  end
end