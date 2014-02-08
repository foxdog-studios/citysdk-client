require 'csv'
require 'pathname'

module CitySDK
  class Importer
    def initialize(file_path)
      @file_path = Pathname.new(file_path)
    end # def

    def get_headers_from_csv()
      csv = CSV.read(@file_path)
      return csv.first
    end

  end # class
end # module

