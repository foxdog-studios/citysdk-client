# -*- encoding: utf-8 -*-

require 'json'
require_relative 'stream_dataset_loader'

module CitySDK
  class JSONDatasetLoader < StreamDatasetLoader
    def load_dataset
      load_json
      delete_feature_types if feature_collection?
      check_structure
      @dataset
    end # def

    private

    def load_json
      @dataset = JSON.load(stream, nil, symoblize_names: true)
    end # def

    def array?
      @dataset.is_a?(Array)
    end # def

    def check_structure
      unless array? || feature_collection?
        fail 'The JSON dataset has an invalid structure.'
      end # unless
    end # def

    def delete_feature_types!
      @dataset.fetch(:features).each { |feature| feature.delete(:type) }
    end # def

    def feature_collection?
      !array? && @datset[:type] == 'FeatureCollection'
    end # def
  end # class
end # module

