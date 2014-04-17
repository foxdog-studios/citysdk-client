# -*- encoding: utf-8 -*-

require 'geo_ruby/shp'
require_relative 'abstract_dataset_loader'

module CitySDK
  class ShapeDatasetLoader < AbstractDatasetLoader
    private

    def load_dataset
      open { |shapes| return shapes_to_dataset(shapes) }
    end # def

    def open(&block)
      GeoRuby::Shp4r::ShpFile.open(path.to_s, &block)
    end # def

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

