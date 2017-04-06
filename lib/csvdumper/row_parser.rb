module Csvdumper
  class RowParser
    MINIMAL_COLUMNS_COUNT = 2

    class << self
      def parse(row)
        return nil unless row_valid?(row)
        {
          ip_address:   row[0].to_s.strip,
          country_code: row[1].to_s.strip,
          country:      row[2].to_s.strip,
          city:         row[3].to_s.strip,
          latitude:     row[4].to_s.strip,
          longitude:    row[5].to_s.strip,
        }
      end

      private

      def row_valid?(row)
        row.kind_of?(Array) && row.count > MINIMAL_COLUMNS_COUNT
      end
    end
  end
end
