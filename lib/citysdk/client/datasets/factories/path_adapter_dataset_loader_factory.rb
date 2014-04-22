# -*- encoding: utf-8 -*-

require_relative '../loaders/path_adapter_dataset_loader'
require_relative 'path_dataset_loader_factory'
require_relative 'stream_dataset_loader_factory'

module CitySDK
  class PathAdapterDatasetLoaderFactory
    def initialize
      @path_factory = PathDatasetLoaderFactroy.new
      @stream_factory = StreamDatasetLoaderFactory.new
    end # def

    def create(path, format = nil)
      create_format(path, ensure_format(path, format))
    end # def

    private

    def create_adapter(path, format)
      PathAdapterDatasetLoader.new(
        @stream_factory.get_loader_class(format),
        path
      )
    end # def

    def create_path(path, format)
      @path_factory.create(path, format)
    end # def

    def create_format(path, format)
      if path_adapter?(format)
        create_adapter(path, format)
      else
        create_path(path, format)
      end # else
    end # def

    def ensure_format(path, format)
      format || @path_factory.format_from_path(path)
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

