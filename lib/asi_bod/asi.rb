
require 'nori'

module AsiBod
  class Asi
    attr_reader :nori
    attr_reader :raw_data
    attr_reader :array_data
    attr_reader :hash_data

    def initialize(global_options, options, args)
      @nori = Nori.new
      @raw_data = @nori.parse(File.read(global_options[:asi_file]))
      @array_data = @raw_data["InternalAppEntity"]["Parameters"].first[1]
      @hash_data = array_data_to_hash(@array_data)
    end

    # Convert the array of hashes to a hash with the address as primary key
    def array_data_to_hash(array_data)
      array_data.each_with_object({}) do |node, memo|
        memo[node["Address"].to_i] = clean_node(node)
      end
    end

    def clean_node(node)
      node.each_with_object({}) do |(k,v), memo|
        next if k == "@FaultIndicator" || k == "BitField" # Skip these pairs
        key = k.sub(k[0], k[0].downcase) # Make it uncapitalized
        memo[key.to_sym] = v
      end
    end
  end
end
