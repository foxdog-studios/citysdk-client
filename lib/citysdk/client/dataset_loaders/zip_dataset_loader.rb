# -*- encoding: utf-8 -*-

require 'pathname'
require 'tmpdir'
require_relative 'path_dataset_loader'

module CitySDK
  class ZipDatasetLoader < PathDatasetLoader
    def load
      Dir.mktmpdir do |extract_dir|
        extract_dir = Pathname.new(extract_dir)
        unzip(extract_dir)
        load_files(extract_dir)
      end # do
    end # def

    private

    def unzip(extract_dir)
      # TODO: Replace this with a Ruby Zip library so that we get clear
      #       errors when something goes wrong and remove the
      #       possibility of shell injections.
      command = "unzip '#{path}' -d '#{extract_dir}' > /dev/null 2>&1"
      unless system(command)
        fail "Failed to unzip #{path.inspect}."
      end # unless
    end # def

    def load_files(extract_dir)
      datasubset = []
      Dir.foreach(extract_dir) do |extracted_name|
        datasubset += load_file(extract_dir.join(extracted_name))
      end # do
      datasubset
    end # def

    def load_file(extracted_path)
      FileDatasetLoader.new(extracted_path).dataset
    end # def
  end # class
end # module

