module CitySDK
  APIError = Class.new(StandardError)

  LAYER_PATH = 'layer'
  LAYERS_PATH = 'layers'
  NODE_PATH = 'nodes'

  class API
    def initialize(conn)
      @conn = conn
    end

    def set_credentials(email, password)
      @conn.basic_auth(email, password)
    end


    # ==========================================================================
    # = Layers                                                                 =
    # ==========================================================================

    def layer?(name)
      response = get("/#{CitySDK::LAYER_PATH}/#{name}/")
      case response.status
      when 200 then true
      when 404 then false
      else api_error(response)
      end # case
    end # def

    def create_layer(attributes)
      data = { data: attributes }.to_json
      response = put("/#{CitySDK::LAYERS_PATH}/", data)
      api_error(response) if response.status != 200
      return
    end # def

    def get_layers
      response = get("/#{CitySDK::LAYERS_PATH}/")
      api_error(response) if response.status != 200
      parse_body(response)
    end # def

    def get_layer(name)
      response = get("/#{CitySDK::LAYER_PATH}/#{name}/")
      api_error(response) if response.status != 200
      parse_body(response)
    end # def

    def set_layer_status(name, status)
      put("/#{CitySDK::LAYER_PATH}/#{name}/status", data: status)
    end # def


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
        node_type: NODE_TYPE_PTSTOP
      }
      params = default_params.merge(params)
      data = { create: { params: params }, nodes: nodes }.to_json
      response = put("/nodes/#{layer}", data)
      if response.status != 200
        fail APIError, response.body
      end # if
    end # def

    def get_nodes(query_params)
      uri = Addressable::URI.new
      uri.query_values = query_params
      response = get("/#{CitySDK::NODE_PATH}/?#{uri.query}")
      api_error(response) if response.status != 200
      parse_body(response)
    end # def


    # ==========================================================================
    # = Matching                                                               =
    # ==========================================================================

    def match_node(node, *args)
      match_nodes([node], *args)
    end # def

    def match_nodes(nodes, params = {})
      data = { create: { params: params }, nodes: nodes }.to_json
      post('/util/match', data)
    end # def

    def match_and_create_node(layer, node)
      match_and_create_nodes(layer, [nodes])
    end # def

    def match_and_create_nodes(layer, nodes)
      json = parse_body(match_nodes(nodes))
      create_nodes(json.fetch('nodes'))
    end # def

    private

    def get(path)
      @conn.get(path)
    end # def

    def post(path, data)
      @conn.post(path, data) { |req| set_content_type(req) }
    end # def

    def put(path, data)
      @conn.put(path, data) { |req| set_content_type(req) }
    end # def

    def set_content_type(req)
      req.headers['Content-Type'] = 'application/json'
    end # def

    def delete(path)
      @conn.delete(path)
    end # def

    def parse_body(response)
      JSON.parse(response.body)
    end # def

    def api_error(response)
      begin
        json = parse_body(response)
      rescue
        message = response.body
      else
        message = json.key?('error') ? json['error'] : response.body
      end # else
      fail APIError, message
    end # def
  end # class
end # module

