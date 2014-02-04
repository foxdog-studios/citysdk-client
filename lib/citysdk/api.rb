require 'json'
require 'faraday'

module CitySDK

  class HostException < ::Exception
  end

  class API
    attr_reader :error
    attr_accessor :batch_size

    @@match_tpl = {
      :match => {
        :params => {}
      },
      :nodes => []
    }
    @@create_tpl =  {
      :create => {
        :params => {
          :create_type => "create"
        }
      },
      :nodes => []
    }

    def initialize(host, port = nil)
      @error = '';
      @layer = '';
      @batch_size = 10;
      @updated = @created = 0;
      set_host(host, port)
    end

    def authenticate(email, password)
      @email = email
      @passw = password
      @conn.basic_auth(email, password)
    end

    def set_host(host, port = nil)
      @host = host
      @port = port

      if port.nil?
        if host =~ /^(.*):(\d+)$/
          @port = $2
          @host = $1
        else
          @port = 80
        end
      end

      @conn = Faraday.new :url => "http://#{@host}:#{@port}"
      @conn.headers = {
        :user_agent => 'CitySDK_API GEM ' + CitySDK::VERSION,
        :content_type => 'application/json'
      }
      begin
        get('/')
      rescue Exception => e
        raise CitySDK::Exception.new("Trouble connecting to api @ #{host}")
      end
      @create = @@create_tpl
      @match = @@match_tpl
    end

    def set_matchTemplate(mtpl)
      mtpl[:nodes] = []
      @match = @@match_tpl = mtpl
    end

    def set_createTemplate(ctpl)
      ctpl[:nodes] = []
      @create = @@create_tpl = ctpl
    end

    def set_layer(l)
      @layer = l
    end

    def set_layer_status(status)
      put("/layer/#{@layer}/status",{:data => status})
    end

    def match_node(n)
      @match[:nodes] << n
      return match_flush if @match[:nodes].length >= @batch_size
      return nil
    end

    def match_create_node(n)
      @match[:nodes] << n
      return match_create_flush if @match[:nodes].length >= @batch_size
    end

    def create_node(n)
      @create[:nodes] << n
      create_flush if @create[:nodes].length >= @batch_size
    end

    def delete(path)
      resp = @conn.delete(path)
      if resp.status == 200
        return CitySDK::parseJson(resp.body)
      end
      @error = CitySDK::parseJson(resp.body)[:message]
      raise HostException.new(@error)
    end

    def post(path,data)
      resp = @conn.post(path,data.to_json)
      if resp.status != 200
        @error = CitySDK::parseJson(resp.body)[:message]
        raise HostException.new(@error)
      end # if
      CitySDK::parseJson(resp.body)
    end

    def put(path,data)
      resp = @conn.put(path,data.to_json)
      return CitySDK::parseJson(resp.body) if resp.status == 200
      @error = CitySDK::parseJson(resp.body)[:message]
      raise HostException.new(@error)
    end

    def get(path)
      resp = @conn.get(path)
      return CitySDK::parseJson(resp.body) if resp.status == 200
      @error = CitySDK::parseJson(resp.body)[:message]
      raise HostException.new(@error)
    end

    def match_create_flush

      if @match[:nodes].length > 0
        resp = post('util/match',@match)
        if resp[:nodes].length > 0
          @create[:nodes] = resp[:nodes]
          res = put("/nodes/#{@layer}",@create)
          tally(res)
          clear_create_nodes
        end
        clear_match_nodes
        res
      end
      nil
    end

    def match_flush
      if @match[:nodes].length > 0
        resp = post('util/match',@match)
        clear_match_nodes
        return resp
      end
    end


    def create_flush
      if @create[:nodes].length > 0
        tally put("/nodes/#{@layer}",@create)
        clear_create_nodes
      end
    end

    def tally(res)
      if res[:status] == "success"
        # TODO: also tally debug data!
        @updated += res[:create][:results][:totals][:updated]
        @created += res[:create][:results][:totals][:created]
      end
    end

    def clear_nodes
      clear_create_nodes
      clear_match_nodes
    end

    def clear_match_nodes
      @match[:nodes] = []
    end

    def clear_create_nodes
      @create[:nodes] = []
    end
  end
end

