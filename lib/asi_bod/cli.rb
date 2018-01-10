require 'gli'
require 'json'
require 'pp'

module AsiBod

  class Cli
    attr_reader :asi
    attr_reader :bod

    include GLI::App

    GPARENT = GLI::Command::PARENT

    KEY_ORDER = { address: 0,
                  name: 1,
                  description: 2,
                  scale: 3,
                  units: 4,
                  read: 5,
                  write: 6 }

    def which_keys(options)
      options.each_with_object([]) do |(k,v), memo|
        if k.is_a?(String) && k.include?('_view')
          # Its a view key
          next unless options[k]
          # Strip off the '_view' and convert to a symbol
          key = k[0..(k.index('_view') - 1)].to_sym
          # Store them in KEY_ORDER
          memo[KEY_ORDER[key]] = key
        end
      end.compact
    end

    # Main body. Does all the CLI processing and dispatching
    def main
      program_desc 'Manipulate and view the ASIObjectDictionary.xml and BOD.json files'

      version AsiBod::VERSION

      subcommand_option_handling :normal
      arguments :strict
      sort_help :manually

      desc 'Path to the ASIObjectDictionary XML file'
      default_value Asi.default_file_path
      flag [:a, :asi_file]

      desc 'Path to the BOD JSON file'
      default_value Bod.default_file_path
      flag [:b, :bod_file]

      desc 'View Address'
      switch :address_view, default_value: true

      desc 'View Name'
      switch :name_view, default_value: true

      desc 'View Description'
      switch :description_view, default_value: true

      desc 'View Scale'
      switch [:s, :scale_view]

      desc 'View Units'
      switch [:u, :units_view]

      desc 'View the data'
      command :view do |view|
        view.desc 'Pretty Print output of the simplified ASI ObjectDictionary as a hash'
        view.command :asi do |view_asi| 
          view.desc 'Output as Json instead of CSV'
          view.switch [:j, :json]

          view_asi.action do |global_options, options, args|
            if options[GPARENT][:json]
              puts JSON.pretty_generate asi.hash_data
            else
              Dict.specific_keys_per_node(
                asi.hash_data,
                which_keys(global_options)) do |address, node|
                puts node
              end
            end
          end
        end

        view.desc 'Pretty Print output of the simplified BOD as a hash'
        view.command :bod do |view_bod|
          view_bod.action do |global_options,options,args|
            if options[GPARENT][:json]
              puts JSON.pretty_generate bod.hash_data
            else
              Dict.specific_keys_per_node(
                bod.hash_data,
                which_keys(global_options)).each_pair do |address, node|
                puts node
              end
            end
          end
        end
        view.default_command :bod
      end

      desc 'Find a node in one or both of the dictionaries'
      command :find do |find|
        find.desc 'Search the asi dictionary'
        find.switch [:a, :asi]

        find.desc 'Search the bod dictionary'
        find.switch [:b, :bod]

        find.desc 'Find by register address'
        find.long_desc 'Find by register address. ' +
                       'Must select at least one of ' +
                       'asi or bod and specify search_term'
        find.arg 'address'
        find.command :by_address do |find_by_address| 
          find_by_address.action do |global_options, options, args|
            address = args.first
            # puts "find_by_address global_options #{global_options.inspect} options: #{options.inspect} args: #{args.inspect}"
            puts "asi: => " +
                 "#{Dict.node_line(asi.hash_data[address.to_i],
                    which_keys(global_options))}" if options[GPARENT][:asi]
            puts "bod: => " +
                 "#{Dict.node_line(bod.hash_data[address.to_i],
                    which_keys(global_options))}" if options[GPARENT][:bod]
          end
        end

        find.desc 'Find by the substring of a key'
        find.long_desc 'Find by the substring of ' +
                       'a Must select at least one of ' +
                       'asi or bod and specify search_term'
        find.arg 'node_key'
        find.arg 'substring'
        find.command :by_key_substring do |find_by_key_substring| 
          find_by_key_substring.action do |global_options, options, args|
            key = args[0].to_sym
            substring = args[1]
            if options[GPARENT][:asi]
              puts "asi: key: #{key} substring: #{substring} => "
              Dict.put_results(
                Dict.find_by_key_substring(asi.hash_data, key, substring),
                which_keys(global_options)
              )
            end
            if options[GPARENT][:bod]
              puts "bod: key: #{key} substring: #{substring} => "
              Dict.put_results(
                Dict.find_by_key_substring(bod.hash_data, key, substring),
                which_keys(global_options)
              )
            end
          end
        end
      end

      desc 'Merge the Description from asi to bod'
      long_desc 'Merge the Description from asi to bod ' +
                'Do not merge if Description has "Reserved" in it ' +
                'Or if the Bod doesnt have the key'
      command :merge do |merge|
        merge.desc 'Output Json'
        merge.switch [:j, :json]
        merge.action do |global_options,options,args|
          raw_result = Dict.merge(asi.hash_data, bod.hash_data)
          result = if options[:json]
                     JSON.pretty_generate raw_result
                   else
                     raw_result.pretty_inspect
                   end
          puts result
        end
      end

      pre do |global_options, command, options, args|
        # Pre logic here
        # Return true to proceed; false to abort and not call the
        # chosen command
        # Use skips_pre before a command to skip this block
        # on that command only
        @asi = AsiBod::Asi.new(global_options)
        @bod = AsiBod::Bod.new(global_options)
      end

      post do |global_options, command, options, args|
        # Post logic here
        # Use skips_post before a command to skip this
        # block on that command only
      end

      on_error do |exception|
        # Error logic here
        # return false to skip default error handling
        true
      end

      exit run(ARGV)
    end
  end
end
