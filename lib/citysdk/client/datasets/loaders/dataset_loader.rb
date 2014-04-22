# -*- encoding: utf-8 -*-

module CitySDK
  class DatasetLoader
    def load_dataset
      fail 'Subclass must implement load_dataset but does not.'
    end # def
  end # class
end # module

