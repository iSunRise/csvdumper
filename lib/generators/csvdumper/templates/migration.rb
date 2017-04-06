class CsvdumperCreateIpLocations < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :csvdumper_ip_locations do |t|
      t.string :ip_address,   null: false, index: true
      t.string :country,          null: false
      t.string :country_code
      t.string :city
      t.float  :latitude
      t.float  :longitude

      t.timestamps
    end
  end
end