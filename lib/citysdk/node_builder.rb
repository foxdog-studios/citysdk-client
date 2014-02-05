require 'csv'
require 'tmpdir'

require 'geo_ruby'
require 'geo_ruby/shp'
require 'geo_ruby/geojson'


module CitySDK
  class NodeBuilder
    def initialize
      @nodes = []
      factory = GeoRuby::SimpleFeatures::GeometryFactory::new
      @wkb_parser = GeoRuby::SimpleFeatures::HexEWKBParser.new(factory)
    end # def

    def build
      @nodes.dup
    end # def

    def load_data_set_from_csv!(path)
      @nodes += load_data_set_from_csv(path)
      return
    end # def

    def load_data_set_from_json!(path)
      @nodes += load_data_set_from_json(path)
      return
    end# def

    def load_data_set_from_shp!(path)
      @nodes += load_data_set_from_shp(path)
      return
    end # def

    def load_data_set_from_zip!(path)
      @nodes += load_ata_set_from_zip(path)
      return
    end # def

    def set_node_id_from_data_field!(field)
      set_node_attr_from_data_field!(:id, field)
    end # def

    def set_node_name_from_data_field!(field)
      set_node_attr_from_data_field!(:name, field)
    end # def

    def set_geometry_from_geo_json!(field)
      set_geometry_from_field!(field)
    end # def

    def set_geometry_from_field!(field)
      @nodes.each do |node|
        node[:geometry] = node.fetch(:data).delete(field)
      end # do
      return
    end # def

    def set_geometry_from_lat_lon!(lat, lon)
      @nodes.each do |node|
        data = node.fetch(:data)
        pop = lambda { |key| data.delete(key).to_f }
        coordinates = [pop.call(lon), pop.call(lat)]
        # Point must be capitalised for RGeo decode.
        set_geometry_on_node!(node, 'Point', coordinates: coordinates)
      end
      return
    end

    def set_geometry_from_wkb_geometry!(field)
      @nodes.each do |node|
        geometry = node.fetch(:data).delete(field)
        geometry = @wkb_parser.parse(geometry)
        set_geometry_on_node!(node, 'wkb', wkb: geometry)
      end
      return
    end


    # ==========================================================================
    # = Reading                                                                =
    # ==========================================================================

    private

    def load_data_set_from_csv(path)
      data_set = CSV.foreach(path, headers: true, skip_blanks: true) do |row|
        row.to_hash
      end
      make_nodes(data_set)
    end

    def load_data_set_from_json(path)
      json = open(path) { |file| JSON.load(file, nil, symoblize_names: true) }
      data_set =
        if json.is_a?(Array)
          json
        elsif json[:type] == 'FeatureCollection'
          process_feature_collection(json)
        else
          fail "Cannot import JSON from #{ path }."
        end # else
      make_nodes(data_set)
    end # def

    def process_feature_collection(json)
      json.fetch(:features).map do |feature|
        feature.delete(:type)
        feature
      end # do
    end # def

    def load_data_set_from_shp(path)
      GeoRuby::Shp4r::ShpFile.open(path) do |shape_file|
        fields = shape_file.fields
        shape_file.map do |shape|
          node = { geometry: shape.geometry }
          node[:data] = data = {}
          fields.map do |field|
            name = field.name
            data[name] = shape.data.fetch(name)
          end # do
        end # do
      end # do
    end # def

    def load_data_set_from_zip(path)
      Dir.mktmpdir do |dir|
        unless system "unzip '#{ path }' -d '#{ dir }' > /dev/null 2>&1"
          fail "Cannot unzip #{ path }."
        end # unless
        Dir.foreach(dir) do |file_name|
          ext = File.extname(file_name)
          path = File.join(dir, file_name)
          case ext
          when '.csv'          then load_data_set_from_csv!(path)
          when '.geo', '.json' then load_data_set_from_json!(path)
          when '.shp'          then load_data_set_from_shp!(path)
          else raise "Cannot deduce file format from extension '#{ ext }'"
          end # case
        end # do
      end # do
    end # def


    # ==========================================================================
    # = Helpers                                                                =
    # ==========================================================================

    def make_nodes(data_set)
      data_set.map { |data| { data: data } }
    end # def

    def set_node_attr_from_data_field!(node_attr, data_field)
      @nodes.each do |node|
        node[node_attr] = node.fetch(:data).fetch(data_field)
      end
    end # def

    def set_geometry_on_node!(node, type, geometry)
      node[:geometry] = { type: type }.merge(geometry)
    end # def

  end # class
end # module

