class Csvdumper::IpLocation < <%= rails5? ? 'ApplicationRecord' : 'ActiveRecord::Base' %>
  self.table_name = 'csvdumper_ip_locations'
  validates :ip_address, :country, presence: true
  validates :ip_address, :country, :country_code, :city, length: { maximum: 255 }
end
