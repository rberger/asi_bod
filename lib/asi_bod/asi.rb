
require 'nori'

module AsiBod

  # Handle reading in ASI ObjectDictionary and doing operations on it
  class Asi
    attr_reader :nori
    attr_reader :raw_data
    attr_reader :array_data
    attr_reader :hash_data

    # Returns the path to the default ASIObjectDictionary.xml file
    def self.default_file_path
      File.expand_path('../../../ASIObjectDictionary.xml', __FILE__)
    end

    # Asi.new reads in the source file for the ASIObjectDictionary and creates
    # an internal Hash
    # @param params [Hash]
    def initialize(params = { asi_file: default_file_path })
      @nori = Nori.new
      @raw_data = @nori.parse(File.read(params[:asi_file]))
      @array_data = @raw_data['InternalAppEntity']['Parameters'].first[1]
      @hash_data = array_data_to_hash(@array_data)
    end

    # Convert the array of hashes to a hash with the address as primary key
    def array_data_to_hash(array_data)
      array_data.each_with_object({}) do |node, memo|
        memo[node['Address'].to_i] = clean_node(node)
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
