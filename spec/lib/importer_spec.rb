require 'spec_helper'
require 'csv'
require 'active_record'
require 'pry'

class Csvdumper::IpLocation < ActiveRecord::Base
  def self.inspect; end
end

module Csvdumper
  RSpec.describe Importer do

    let(:csv) { CSV.open('./spec/fixtures/example.csv') }

    before do
      allow(Csvdumper::IpLocation).to receive(:new) { |args| OpenStruct.new(args.merge(valid?: true)) }
      allow(ActiveRecord::Base).to receive(:transaction).and_yield
      allow(Csvdumper::IpLocation).to receive(:import)
      allow(ProgressBar).to receive(:create).and_return(OpenStruct.new(increment: true))
    end

    describe 'progress bar' do
      it 'should create progressbar' do
        expect(ProgressBar).to(
          receive(:create)
            .with(total: 6, format: "%a Items: %c/%C [%B] %E")
            .and_return(OpenStruct.new)
        )
        Importer.run(csv, 0, 500)
      end

      it 'should increment progressbar on each processed row' do
        progress = OpenStruct.new(increment: true)
        expect(ProgressBar).to receive(:create).and_return(progress)
        csv_rows_count = 6
        expect(progress).to receive(:increment).exactly(csv_rows_count).times
        Importer.run(csv, 0, 500)
      end
    end

    describe 'bulk import' do
      before do
        progress = OpenStruct.new(increment: true)
        expect(ProgressBar).to receive(:create).and_return(progress)
      end

      it 'should perform insert into db once' do
        expect(Csvdumper::IpLocation).to receive(:import).once
        Importer.run(csv, 0, 500)
      end

      it 'should perform insert into db 3 times' do
        expect(Csvdumper::IpLocation).to receive(:import).exactly(3).times
        Importer.run(csv, 0, 2)
      end
    end

    describe 'statistic' do
      it 'should return correct number of saved entries' do
        statistic = Importer.run(csv, 0, 2)
        valid_entries_in_csv = 5 # actually 4 but we don't validate in this case
        expect(statistic[:saved_records]).to eq(valid_entries_in_csv)
      end
    end
  end
end
