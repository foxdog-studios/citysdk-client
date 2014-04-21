# -*- encoding: utf-8 -*-

require_relative 'csv_dataset_loader'
require_relative 'dataset_loader_factory'
require_relative 'json_dataset_loader'
require_relative 'kml_dataset_loader'

module CitySDK
  class StreamDatasetLoaderFactory < DatasetLoaderFactory
    def initialize
      super(
        csv: CSVDatasetLoader,
        json: JSONDatasetLoader,
        kml: KMLDatasetLoader
      )
    end # def
  end # class
end # module

