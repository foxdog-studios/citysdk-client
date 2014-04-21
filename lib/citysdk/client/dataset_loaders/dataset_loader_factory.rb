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
      @formats.fetch(format.to_sym)
    end # def

    def supports?(format)
      @formats.key?(format.to_sym)
    end # def
  end # class
end # moudle

