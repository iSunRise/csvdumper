require 'ruby-progressbar'

module Csvdumper
  class Importer
    attr_accessor :csv, :header_row_index, :bulk_size, :statistic, :bulk

    def self.run(csv, header_row_index = 0, bulk_size = 500)
      new(csv, header_row_index, bulk_size).execute
    end

    def initialize(csv, header_row_index, bulk_size)
      @csv = csv
      @header_row_index = header_row_index
      @bulk_size = bulk_size
      @statistic = Hash.new(0)
      @bulk = []
    end

    def execute
      progressbar = create_progress_bar(csv.each.count)
      csv.rewind

      ActiveRecord::Base.transaction do
        csv.each_with_index do |row, index|
          progressbar.increment
          next if index <= header_row_index

          record = process_csv_row(row)
          if record
            bulk << record
            import_bulk if bulk.size >= bulk_size
          end
        end
        import_bulk if bulk.size > 0
      end
      statistic
    end

    private

    def import_bulk
      Csvdumper::IpLocation.import(bulk)
      self.bulk = []
    end

    def process_csv_row(row)
      params = Csvdumper::RowParser.parse(row)
      if params.nil?
        statistic[:empty_data] += 1
        return
      end

      record = Csvdumper::IpLocation.new(params)
      if record.valid?
        statistic[:saved_records] += 1
        record
      else
        statistic[:invalid_data] += 1
        nil
      end
    end

    def create_progress_bar(items_count)
      ProgressBar.create(total: items_count, format: "%a Items: %c/%C [%B] %E")
    end
  end
end