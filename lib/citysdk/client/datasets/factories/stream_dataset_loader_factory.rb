# -*- encoding: utf-8 -*-

require_relative '../loaders/csv_dataset_loader'
require_relative '../loaders/json_dataset_loader'
require_relative '../loaders/kml_dataset_loader'
require_relative 'abstract_dataset_loader_factory'

module CitySDK
  class StreamDatasetLoaderFactory < AbstractDatasetLoaderFactory
    def initialize
      super(
        csv: CSVDatasetLoader,
        json: JSONDatasetLoader,
        kml: KMLDatasetLoader
      )
    end # def
  end # class
end # module

