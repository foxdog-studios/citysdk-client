# -*- encoding: utf-8 -*-

require 'geo_ruby'
require 'geo_ruby/kml'
require 'nokogiri'
require_relative 'abstract_dataset_loader'

module CitySDK
  class KMLDatasetLoader < AbstractDatasetLoader
    def initialize(path)
      super(path)

      factory = GeoRuby::SimpleFeatures::GeometryFactory.new
      @kml_parser = GeoRuby::KmlParser.new(factory)
    end # def

    private

    attr_reader :kml_parser

    def load_dataset
      File.open(path) { |kml|  kml_to_dataset(kml) }
    end # def

    def kml_to_dataset(kml)
      [geometry: kml_to_geometry(kml)]
    end # def

    def kml_to_geometry(kml)
      dom_to_geometry(kml_to_dom(kml))
    end # def

    def kml_to_dom(kml)
      Nokogiri.XML(kml)
    end # def

    def dom_to_geometry(dom)
      kml_parser.parse(dom.to_s)
    end # def
  end # class
end # module

