module CitySDK
  class NodesPaginator
    def initialize(api, query_params)
      @api = api
      @query_params = query_params
      @has_next = true
      @query_params['page'] = 1
    end

    def has_next
      return @has_next
    end

    def next
      nodes = @api.get_nodes(@query_params)
      next_page = nodes['next_page']
      @query_params['page'] = next_page
      if next_page == -1
        @has_next = false
      end # if
      return nodes
    end # def
  end # class
end # module

