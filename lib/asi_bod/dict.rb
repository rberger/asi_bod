require 'pp'

module AsiBod

  # Manipulate the unified Hash that can contain the data from
  # ASIObjectDictionary or BOD
  class Dict
    # Find a node in the dict by the value of the specified key
    # @params dict [Hash] The unified Hash of Hashes that represents the ASIObjectDictionary or BOD data
    # @params key [Symbol] The Key that will be search against
    # @params search_value [String, Symbol] The value to search for
    # @params output_keys [Array] What keys of the node to return
    # @return [Array<Hash>] Array of Dict nodes scoped by output_keys
    def self.find_by_key_substring(dict, key, search_value, output_keys)
      dict.each_with_object({}) do |(k, v), memo|
        next if v[key].nil?
        memo[k] = node_line(v, output_keys) if v[key].to_s.include? search_value
      end
    end

    # Takes a node and returns an array of elements in the order the keys specify
    # @param node [Hash] The node hash
    # @param keys [Array] Ordered array of keys to select which elements to return
    def self.node_line(node, keys)
      keys.map { |k| node[k] }.join(", ")
    end

    # Takes a hash of results (subset of a Dict Hash) and puts a result per line
    # with only the keys specified
    # @param results [Hash] The subset of a full asi or bod Hash
    # @param keys [Array] Optional array of keys to display
    # @return [Hash<Symbol>,<Hash>] Hash of Hashes with each hash having specified keys
    def self.specific_keys_per_node(dict, keys)
      dict.each_with_object({}) do |(key, node), memo|
        memo[key] = Dict.node_line(node, keys)
      end
    end

    # Merge the descriptions from ASIObjectDictionary Hash of Hashes into BOD
    # Hash of Hashes This is not used often. Allowed the creation of the
    # BODm.json file which has the ASIObjectDictionary Descriptions merged in
    # @param asi [Hash] The Hash of Hashes of the ASIObjectDictionary
    # @param bod [Hash] The Hash of Hashes of the BOD
    def self.merge(asi, bod)
      bod.each_with_object({}) do |(address, node), memo|
        memo[address] = node
        if (asi[address][:description].nil? ||
            asi[address][:description].include?('Reserved') rescue true)
          memo[address][:description] = nil
        end
        memo[address][:description] = asi[address][:description]
      end
    end
  end
end

