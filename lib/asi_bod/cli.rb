require 'gli'
require 'pp'

module AsiBod

  class Cli
    include GLI::App

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
      command :view do |c|
        c.desc "Pretty Print output of the simplified ASI ObjectDictionary as a hash"
        c.command :asi do |asi| 
          asi.action do |global_options,options,args|
            asi = AsiBod::Asi.new(global_options,options,args)
            pp asi.hash_data
          end
        end

        c.command :bod do |bod|
          bod.action do |global_options,options,args|
            bod = AsiBod::Bod.new(global_options,options,args)
            pp bod.hash_data
          end
        end
      end
      desc 'Find a node in one of the files'
      command :find do |c|
        c.desc 'Use XML File'
        c.switch [:x,:xml]

        c.action do |global_options,options,args|

          # Your command logic here
          # If you have any errors, just raise them
          # raise "that command made no sense"

          puts "find command ran global: #{global_options.inspect} options: #{options.inspect} args: #{args.inspect}"
        end
      end

      desc 'Describe merge here'
      arg_name 'Describe arguments to merge here'
      command :merge do |c|
        c.action do |global_options,options,args|
          puts "merge command ran global: #{global_options.inspect} options: #{options.inspect} args: #{args.inspect}"
        end
      end

      pre do |global,command,options,args|
        # Pre logic here
        # Return true to proceed; false to abort and not call the
        # chosen command
        # Use skips_pre before a command to skip this block
        # on that command only
        Asi.new global,options,args
        true
      end

      post do |global,command,options,args|
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
