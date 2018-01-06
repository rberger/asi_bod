require 'json'

module AsiBod
  class Bod
    attr_reader :hash_data

    def initialize(global,options,args)
      @json_data = JSON.parse(File.read(global[:bod_file]))
      @hash_data = json_data_to_hash(@json_data)
    end

    def json_data_to_hash(json_data)
      json_data.each_with_object({}) do |(k, v), memo|
        memo[k.to_i] = clean_node(v)
      end
    end

    def clean_node(node)
      node.each_with_object({}) do |(k, v), memo|
        memo[k.to_sym] = v
      end
    end
  end
end
