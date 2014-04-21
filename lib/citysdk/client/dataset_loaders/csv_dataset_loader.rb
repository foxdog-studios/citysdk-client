# -*- encoding: utf-8 -*-

require 'csv'
require_relative 'stream_dataset_loader'

module CitySDK
  class CSVDatasetLoader < StreamDatasetLoader
    def load
      CSV.new(stream, headers: true, skip_blanks: true).map do |row|
        { data: row.to_hash }
      end # do
    end # def
  end # class
end # module

