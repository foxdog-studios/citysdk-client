# -*- encoding: utf-8 -*-

require 'pathname'
require_relative 'abstract_dataset_loader'
require_relative 'csv_dataset_loader'
require_relative 'json_dataset_loader'
require_relative 'kml_dataset_loader'
require_relative 'shape_dataset_loader'

module CitySDK
  class FileDatasetLoader < AbstractDatasetLoader
    def initialize(path, opts = {})
      super(path)
      @format = opts.fetch(:format) { |_| format_from_path }
    end # def

    private

    EXT_TO_FORMAT = {
      '.csv'  => :csv,
      '.geo'  => :json,
      '.json' => :json,
      '.kml'  => :kml,
      '.shp'  => :shp
    }.freeze

    FORMAT_TO_LOADER_CLASS = {
      csv:  CSVDatasetLoader,
      json: JSONDatasetLoader,
      kml:  KMLDatasetLoader,
      shp:  ShapeDatasetLoader
    }.freeze

    def format_from_path
      EXT_TO_FORMAT.fetch(path.extname)
    end # def

    def load_dataset
      open(path) { |data| loader_class.new(data).dataset }
    end # def

    def loader_class
      FORMAT_TO_LOADER_CLASS.fetch(@format)
    end # def
  end # class
end # module

