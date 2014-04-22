# -*- encoding: utf-8 -*-

require_relative 'dataset_loader'

module CitySDK
  class PathDatasetLoader < DatasetLoader
    def initialize(path)
      super()
      @path = path
    end # def

    private

    attr_reader :path
  end # class
end # module

