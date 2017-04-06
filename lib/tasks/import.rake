require 'csv'
require 'activerecord-import'

namespace :csvdumper do
  HEADER_ROW_INDEX = 0
  BULK_SIZE = 500

  desc 'Dump CSV "data_dump.csv" file and imports into database'
  task process: :environment do
    Rake::Task['csvdumper:process_file'].invoke('data_dump.csv', HEADER_ROW_INDEX)
  end

  desc 'Dump given CSV file and imports into database'
  task :process_file, [:csv_file, :header_row_index] => [:environment] do |t, args|
    header_row_index = args[:header_row_index].to_i
    csv = CSV.open File.expand_path(args[:csv_file])

    statistic = Csvdumper::Importer.run(csv, header_row_index, BULK_SIZE)

    report = 'Import finished. Imported: %s, blank rows: %s, invalid rows: %s'
    puts report % [statistic[:saved_records], statistic[:empty_data], statistic[:invalid_data]]
  end
end
