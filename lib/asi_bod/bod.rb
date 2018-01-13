require 'json'

module AsiBod

  # Handle reading in Grin Tech BOD Json file and doing operations on it
  class Bod
    attr_reader :hash_data

    # Returns the path to the default BODm.json file
    def self.default_file_path
      File.expand_path('../../../BODm.json', __FILE__)
    end

    def initialize(params = { bod_file: default_file_path })
      @json_data = JSON.parse(File.read(params[:bod_file]))
      @hash_data = json_data_to_hash(@json_data)
    end

    # Make the Dictionary an pleasant hash with Integer top keys (addresses) and
    # symbols for other keys
    # @params [Hash<String, Hash>] original_dict The BOD Hash as it came from JSON.parse
    # @return [Hash<Integer>, <Hash>] Hash of Hashes where the top key is the address 
    def clean_dict(original_dict)
      original_dict.each_with_object({}) do |(k, v), memo|
        memo[k.to_i] = clean_node(v)
      end
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
