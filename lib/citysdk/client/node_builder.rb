# -*- encoding: utf-8 -*-

module CitySDK
  class NodeBuilder
    def initialize(dataset)
      @nodes = dataset
    end # def

    def nodes
      @nodes.dup
    end # def

    def set_node_id_from_data_field!(field)
      set_node_attr_from_data_field!(:id, field)
    end # def

    def set_node_name_from_data_field!(field)
      set_node_attr_from_data_field!(:name, field)
    end # def

    def set_node_id_from_value!(value)
      set_node_attr_from_value(:id, value)
    end # def

    def set_node_name_from_value!(value)
      set_node_attr_from_value(:name, value)
    end # def

    def set_node_data_from_key_value!(key, value)
      set_node_data_from_key_value(key, value)
    end

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
    end # def

    def set_geometry_from_wkb_geometry!(field)
      @nodes.each do |node|
        geometry = node.fetch(:data).delete(field)
        geometry = @wkb_parser.parse(geometry)
        set_geometry_on_node!(node, 'wkb', wkb: geometry)
      end
      return
    end # def

    def delete_data_field!(field)
      @nodes.each do |node|
        node.fetch(:data).delete(field)
      end
      return
    end

    # ==========================================================================
    # = Helpers                                                                =
    # ==========================================================================

    def set_node_attr_from_data_field!(node_attr, data_field)
      @nodes.each do |node|
        node[node_attr] = node.fetch(:data).fetch(data_field)
      end # do
      return
    end # def

    def set_node_attr_from_value(node_attr, value)
      @nodes.each do |node|
        node[node_attr] = value
      end # do
    end # def

    def set_node_data_from_key_value(key, value)
      @nodes.each do |node|
        unless node.key?('data')
          node['data'] = {}
        end # unless
        node['data'][key] = value
      end # do
    end # def

    def set_geometry_on_node!(node, type, geometry)
      node[:geometry] = { type: type }.merge(geometry)
      return
    end # def
  end # class
end # module

