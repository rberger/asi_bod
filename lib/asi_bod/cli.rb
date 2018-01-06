require 'gli'
require 'json'
require 'pp'

module AsiBod

  class Cli
    attr_reader :asi
    attr_reader :bod

    include GLI::App

    GPARENT = GLI::Command::PARENT
    def main
      program_desc 'Manipulate and view the ASIObjectDictionary.xml and BOD.json files'

      version AsiBod::VERSION

      subcommand_option_handling :normal
      arguments :strict

      desc 'Path to the ASIObjectDictionary XML file'
      default_value 'ASIObjectDictionary.xml'
      flag [:a,:asi_file]

      desc 'Path to the BOD JSON file'
      default_value 'BOD.json'
      flag [:b,:bod_file]

      desc 'View the data'
      command :view do |view|
        view.desc "Pretty Print output of the simplified ASI ObjectDictionary as a hash"
        view.command :asi do |view_asi| 
          view_asi.action do |global_options,options,args|
            pp asi.hash_data
          end
        end

        view.desc "Pretty Print output of the simplified BOD as a hash"
        view.command :bod do |view_bod|
          view_bod.action do |global_options,options,args|
            pp bod.hash_data
          end
        end
      end

      desc 'Find a node in one or both of the dictionaries'
      command :find do |find|
        find.desc "Search the asi dictionary"
        find.switch [:a, :asi] 

        find.desc "Search the bod dictionary"
        find.switch [:b, :bod]

        find.desc "Find by register address"
        find.long_desc %{Find by register address. } +
                       %{Must select at least one of } +
                       %{asi or bod and specify search_term}
        find.arg 'address'
        find.command :by_address do |find_by_address| 
          find_by_address.action do |global_options,options,args|
            address = args.first
            puts "asi: => #{Dict.node_line(asi.hash_data[address.to_i])}" if options[GPARENT][:asi]
            puts "bod: => #{Dict.node_line(bod.hash_data[address.to_i])}" if options[GPARENT][:bod]
          end
        end

        find.desc "Find by the substring of a key"
        find.long_desc %{Find by the substring of } +
                       %{a Must select at least one of } +
                       %{asi or bod and specify search_term}
        find.arg 'node_key'
        find.arg 'substring'
        find.command :by_key_substring do |find_by_key_substring| 
          find_by_key_substring.action do |global_options,options,args|
            key = args[0].to_sym
            substring = args[1]
            if options[GPARENT][:asi]
              puts "asi: key: #{key} substring: #{substring} => "
              Dict.put_results(Dict.find_by_key_substring(asi.hash_data, key, substring))
            end
            if options[GPARENT][:bod]
              puts "bod: key: #{key} substring: #{substring} => "
              Dict.put_results(Dict.find_by_key_substring(bod.hash_data, key, substring))
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
          if options[:json]
            result = JSON.pretty_generate raw_result
          else
            result = raw_result.pretty_inspect
          end
          puts result
        end
      end

      pre do |global_options,command,options,args|
        # Pre logic here
        # Return true to proceed; false to abort and not call the
        # chosen command
        # Use skips_pre before a command to skip this block
        # on that command only
        @asi = AsiBod::Asi.new(global_options,options,args)
        @bod = AsiBod::Bod.new(global_options,options,args)
      end

      post do |global_options,command,options,args|
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
