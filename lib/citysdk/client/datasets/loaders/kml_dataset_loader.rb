# -*- encoding: utf-8 -*-

require 'geo_ruby'
require 'geo_ruby/kml'
require 'nokogiri'
require_relative 'stream_dataset_loader'

module CitySDK
  class KMLDatasetLoader < StreamDatasetLoader
    def load_dataset
      kml_to_dataset(stream)
    end # def

    private

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
      factory = GeoRuby::SimpleFeatures::GeometryFactory.new
      GeoRuby::KmlParser.new(factory).parse(dom.to_s)
    end # def
  end # class
end # module

