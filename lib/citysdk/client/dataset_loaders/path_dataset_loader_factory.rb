# -*- encoding: utf-8 -*-

require_relative 'dataset_loader_factory'
require_relative 'shape_dataset_loader'
require_relative 'zip_dataset_loader'

module CitySDK
  class PathDatasetLoaderFactroy < DatasetLoaderFactory
    def initialize
      super(
        shp: ShapeDatasetLoader,
        zip: ZipDatasetLoader
      )
    end # def
  end # class
end # module

