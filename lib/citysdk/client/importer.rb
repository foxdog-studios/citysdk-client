require 'csv'
require 'pathname'

module CitySDK
  class Importer
    def initialize(file_path)
      @file_path = Pathname.new(file_path)
    end # def

    def get_headers_from_csv
      # If the CSV has blank cells in the first/header row then the
      # Array returned from first has nils in it. Use compact to remove
      # them.
      CSV.read(@file_path).first.compact
    end # def
  end # class
end # module

