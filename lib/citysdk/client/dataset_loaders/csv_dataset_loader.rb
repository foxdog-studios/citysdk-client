# -*- encoding: utf-8 -*-

require 'csv'
require_relative 'abstract_dataset_loader'

module CitySDK
  class CSVDatasetLoader < AbstractDatasetLoader
    private

    def load_dataset
      CSV.read(path, headers: true, skip_blanks: true).map do |row|
        { data: row.to_hash }
      end # do
    end # def
  end # class
end # module

