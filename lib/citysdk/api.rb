require 'json'
require 'faraday'


module CitySDK

  APIError = Class.new(StandardError)

  class API
    def initialize(url)
      @conn = Faraday.new(
        url: url,
        headers: { content_type: 'application/json' }
      )
    end

    def set_credentials(email, password)
      @conn.basic_auth(email, password)
    end


    # ==========================================================================
    # = Layers                                                                 =
    # ==========================================================================

    def layer?(name)
      response = get("/layers/#{ name }/")
      case response.status
      when 200 then true
      when 404 then false
      else api_error(response)
      end # case
    end # def

    def create_layer(attributes)
      data = { data: attributes }.to_json
      response = put('/layers/', data)
      api_error(response) if response.status != 200
      return
    end # def

    def get_layers()
      response = get('/layers/')
      api_error(response) if response.status != 200
      parse_body(response)
    end # def

    def set_layer_status(name, status)
      put("/layers/#{ name }/status", data: status)
    end


    # ==========================================================================
    # = Nodes                                                                  =
    # ==========================================================================

    CREATE_TYPE_CREATE = 'create'
    CREATE_TYPE_ROUTES = 'routes'
    CREATE_TYPE_UPDATE = 'update'

    NODE_TYPE_NODE   = 'node'
    NODE_TYPE_PTSTOP = 'ptstop'
    NODE_TYPE_PTLINE = 'ptline'

    def create_node(layer, node, *args)
      create_nodes(layer, [nodes], *args)
    end

    ##
    # Possible parameters:
    #
    # * create_type (required, client default)
    # * node_type   (required, client default)
    # * srid        (optional, server default)
    def create_nodes(layer, nodes, params = {})
      default_params = {
        create_type: CREATE_TYPE_CREATE,
        node_type:   NODE_TYPE_PTSTOP
      }
      params = default_params.merge(params)
      data = { create: { params: params }, nodes: nodes }.to_json
      response = put("/nodes/#{ layer }", data)
      if response.status != 200
        fail APIError, response.body
      end # if
    end # def


    # ==========================================================================
    # = Matching                                                               =
    # ==========================================================================

    def match_node(node, *args)
      match_nodes([node], *args)
    end

    def match_nodes(nodes, params = {})
      data = { create: { params: params }, nodes: nodes }.to_json
      post('/util/match', data)
    end

    def match_and_create_node(layer, node)
      match_and_create_nodes(layer, [nodes])
    end

    def match_and_create_nodes(layer, nodes)
      json = parse_body(match_nodes(nodes))
      create_nodes(json.fetch('nodes'))
    end

    private

    def get(path)
      @conn.get(path)
    end

    def post(path, data)
      @conn.post(path, data)
    end

    def put(path, data)
      @conn.put(path, data)
    end

    def delete(path)
      @conn.delete(path)
    end

    def parse_body(response)
      JSON.parse(response.body)
    end

    def api_error(response)
      message =
        begin
          parse_body(response)
        rescue
          response.body
        else
          json.key?('error') ? json['error'] : response.body
        end # rescue
      fail APIError, message
    end # def

  end # class
end # module

