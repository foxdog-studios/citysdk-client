# -*- encoding: utf-8 -*-

require_relative '../loaders/dataset_loader'

module CitySDK
  class PathAdapterDatasetLoader < DatasetLoader
    def initialize(stream_loader_class, path)
      @stream_loader_class = stream_loader_class
      @path = path
    end # def

    def load_dataset
      open(@path) { |stream| return load_stream(stream) }
    end # def

    private

    def load_stream(stream)
      @stream_loader_class.new(stream).load_dataset
    end # def
  end # class
end # module

