require 'spec_helper'

module Csvdumper
  RSpec.describe RowParser do

    let(:row) do
      ['200.106.141.15 ', 'SI', 'Nepal', 'DuBuquemouth', '-84.87503094689836', '7.206435933364332', '7823011346']
    end

    it 'should return nil if row is empty' do
      expect(RowParser.parse([])).to eq(nil)
    end

    it 'should return nil if data invalid' do
      expect(RowParser.parse('balblabal')).to eq(nil)
    end

    it 'should correctly map IP address' do
      result = RowParser.parse(row)
      expect(result[:ip_address]).to eq('200.106.141.15')
    end

    it 'should correctly map country name' do
      result = RowParser.parse(row)
      expect(result[:country]).to eq('Nepal')
    end
  end
end
