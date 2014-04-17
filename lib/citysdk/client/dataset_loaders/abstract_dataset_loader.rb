# -*- encoding: utf-8 -*-

require 'pathname'

module CitySDK
  class AbstractDatasetLoader
    def initialize(path)
      @path = Pathname.new(path)
    end # def

    def dataset
      @dataset ||= load_dataset
    end # def

    private

    attr_reader :path

    def load_dataset
      fail 'Subclass must implement load_dataset and does not.'
    end # def
  end # class
end # module

