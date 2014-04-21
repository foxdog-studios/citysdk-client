# -*- encoding: utf-8 -*-

require_relative 'dataset_loader'

module CitySDK
  class PathAdapterDatasetLoader < DatasetLoader
    def initialize(loader_factory, format, path)
      @loader_factory = loader_factory
      @format = format
      @path = path
    end # def

    def load
      open(@path) { |stream| return load_stream(stream) }
    end # def

    private

    def load_stream(stream)
      @loader_factory.create(@format, stream).load
    end # def
  end # class
end # module

