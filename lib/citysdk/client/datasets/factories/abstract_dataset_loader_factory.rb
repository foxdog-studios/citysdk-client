# -*- encoding: utf-8 -*-

module CitySDK
  class AbstractDatasetLoaderFactory
    def initialize(formats)
      @formats = formats
    end # def

    def create(source, format)
      get_loader_class(format).new(source)
    end # def

    def get_loader_class(format)
      @formats.fetch(format.to_sym)
    end # def

    def supports?(format)
      @formats.key?(format.to_sym)
    end # def
  end # class
end # moudle

