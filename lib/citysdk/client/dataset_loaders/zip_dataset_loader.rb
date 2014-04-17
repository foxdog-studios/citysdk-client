# -*- encoding: utf-8 -*-

require 'pathname'
require 'tmpdir'
require_relative 'abstract_dataset_loader'
require_relative 'file_dataset_loader'

module CitySDK
  class ZipDatasetLoader < AbstractDatasetLoader
    private

    def load_dataset
      Dir.mktmpdir do |extract_dir|
        extract_dir = Pathname.new(extract_dir)
        unzip(extract_dir)
        load_files(extract_dir)
      end # do
    end # def

    def unzip(extract_dir)
      # TODO: Replace this with a Ruby Zip library so that we get clear
      #       errors when something goes wrong and remove the
      #       possibility of shell injections.
      command = "unzip '#{path}' -d '#{extract_dir}' > /dev/null 2>&1"
      unless system(command)
        fail "Failed to unzip #{path}."
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

