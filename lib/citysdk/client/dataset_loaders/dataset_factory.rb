# -*- encoding: utf-8 -*-

require_relative 'path_dataset_loader_factory'
require_relative 'stream_dataset_loader_factory'

module CitySDK
  class DatasetFactory
    def initialize
      @path_factory = PathDatasetLoaderFactroy.new
      @stream_factory = StreamDatasetLoaderFactory.new

      @factories = [
        @path_factory,
        @stream_factory
      ]
    end # def

    def load_path(format, path)
      create_path(format, path).load
    end # def

    def load_stream(format, stream)
      create_stream(format, stream).load
    end # def

    private

    def create_path(format, path)
      if path_adapter?(format)
        PathAdapterDatasetLoader.new(@stream_factory, format, path)
      else
        @path_factory.create(format, path)
      end # else
    end # def

    def create_stream(format, stream)
      @stream_factory.create(format, stream)
    end # def

    def path_adapter?(format)
      !path_supports?(format) && stream_supports?(format)
    end # def

    def path_supports?(format)
      @path_factory.supports?(format)
    end # def

    def stream_supports?(format)
      @stream_factory.supports?(format)
    end # def
  end # class
end # module

