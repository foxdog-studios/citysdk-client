# -*- encoding: utf-8 -*-

require_relative '../loaders/shape_dataset_loader'
require_relative '../loaders/zip_dataset_loader'
require_relative 'abstract_dataset_loader_factory'

module CitySDK
  class PathDatasetLoaderFactroy < AbstractDatasetLoaderFactory
    def initialize
      super(
        shp: ShapeDatasetLoader,
        zip: ZipDatasetLoader
      )
    end # def

    def create(path, format = nil)
      super(path, format || format_from_path(path))
    end # def

    def format_from_path(path)
      {
        '.csv'  => :csv ,
        '.geo'  => :csv ,
        '.json' => :json,
        '.kml'  => :kml ,
        '.shp'  => :shp ,
        '.zip'  => :zip
      }.fetch(
        File.extname(path).downcase
      )
    end # def
  end # class
end # module

