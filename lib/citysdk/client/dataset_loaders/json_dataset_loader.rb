# -*- encoding: utf-8 -*-

require 'json'
require_relative 'abstract_dataset_loader'

module CitySDK
  class JSONDatasetLoader < AbstractDatasetLoader
    private

    TYPE_FEATURE_COLLECTION = 'FeatureCollection'.freeze

    def load_dataset
      @json = load_json
      delete_feature_types if feature_collection?
      check_structure
      @json
    end # def

    def load_json
      JSON.load(path, nil, symoblize_names: true)
    end # def

    def array?
      @json.is_a?(Array)
    end # def

    def check_structure
      unless array? || feature_collection?
        fail 'The JSON dataset has an invalid structure.'
      end # unless
    end # def

    def delete_feature_types!
      @json.fetch(:features).each { |feature| feature.delete(:type) }
    end # def

    def feature_collection?
      !array? && @json[:type] == TYPE_FEATURE_COLLECTION
    end # def
  end # class
end # module

