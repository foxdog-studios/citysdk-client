# -*- encoding: utf-8 -*-

require 'test/unit'
require 'citysdk/client'

class TestDatasetFactroy < Test::Unit::TestCase
  def setup
    @factory = CitySDK::DatasetFactory.new
  end # def

  def teardown
    @factory = nil
  end # def

  def test_csv
    load_dataset(:csv)
  end # def

  def test_json
    load_dataset(:json)
  end # def

  def test_kml
    load_dataset(:kml)
  end # def

  def test_shp
    load_path(:shp, expand_path('../shp/dataset.shp'))
  end # def

  # TODO: Find Zip test dataset
  #def test_zip
  #  load_dataset(:zip)
  #end # def

  private

  def expand_path(relative_path)
    File.expand_path(relative_path, __FILE__)
  end # def

  def load_dataset(format)
    load_path(format, expand_path("../dataset.#{format}"))
  end # def

  def load_path(format, path)
    @factory.load_path(format, path)
  end # def
end # class

