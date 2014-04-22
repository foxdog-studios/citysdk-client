# -*- encoding: utf-8 -*-

require 'geo_ruby/shp'
require_relative 'path_dataset_loader'

module CitySDK
  class ShapeDatasetLoader < PathDatasetLoader
    def load_dataset
      GeoRuby::Shp4r::ShpFile.open(path) do |shapes|
        return shapes_to_dataset(shapes)
      end # do
    end # def

    private

    def shapes_to_dataset(shapes)
      shapes.map { |shape| shape_to_data(shapes.fields, shape) }
    end # def

    def shape_to_data(fields, shape)
      { geometry: shape.geometry, data: make_data(fields, shape) }
    end # def

    def make_data(fields, shape)
      data = {}
      fields.each { |field| data[field.name] = shape.data[field.name] }
      data
    end # def
  end # class
end # module

