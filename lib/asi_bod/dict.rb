require 'pp'

module AsiBod

  class Dict
    def self.find_by_key_substring(dict, key, search_string)
      dict.each_with_object({}) do |(k, v), memo|
        next if v[key].nil?
        memo[k] = v if v[key].to_s.include? search_string
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
    def self.put_results(results, keys)
      results.each_pair do |address, node|
        puts Dict.node_line(node, keys)
      end
    end

    def self.merge(asi, bod)
      bod.each_with_object({}) do |(address, node), memo|
        memo[address] = node
        if (asi[address][:description].nil? ||
            asi[address][:description].include?("Reserved") rescue true)
          memo[address][:description] = nil
        end
        memo[address][:description] = asi[address][:description]
      end
    end
  end
end

