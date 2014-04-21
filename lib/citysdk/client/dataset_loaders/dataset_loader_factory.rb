# -*- encoding: utf-8 -*-

module CitySDK
  class DatasetLoaderFactory
    def initialize(formats)
      @formats = formats
    end # def

    def create(format, *args)
      get_loader_class(format).new(*args)
    end # def

    def get_loader_class(format)
      @formats.fetch(format)
    end # def

    def supports?(format)
      @formats.key?(format)
    end # def
  end # class
end # moudle

