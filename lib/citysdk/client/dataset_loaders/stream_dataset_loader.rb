# -*- encoding: utf-8 -*-

require_relative 'dataset_loader'

module CitySDK
  class StreamDatasetLoader < DatasetLoader
    def initialize(stream)
      super()
      @stream = stream
    end # def

    private

    attr_reader :stream
  end # class
end # module

