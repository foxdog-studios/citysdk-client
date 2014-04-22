# -*- encoding: utf-8 -*-

require_relative 'factories/path_adapter_dataset_loader_factory'
require_relative 'factories/stream_dataset_loader_factory'

module CitySDK
  class Dataset
    def self.load_path(path, format = nil)
      self.load_dataset(PathAdapterDatasetLoaderFactory, path, format)
    end # def

    def self.load_stream(stream, format)
      self.load_dataset(StreamDatasetLoaderFactory, stream, format)
    end # def

    private

    def self.load_dataset(factory_class, source, format)
      factory_class.new.create(source, format).load_dataset
    end # def
  end # class
end # module

