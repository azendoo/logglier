module Logglier
  module Client

    def self.new(opts={})
      if opts.nil? or opts.empty?
        raise InputURLRequired.new
      end
      
      opts = { :input_url => opts } if opts.is_a?(String)

      begin
        input_uri = URI.parse(opts[:input_url])
      rescue URI::InvalidURIError => e
        raise InputURLRequired.new("Invalid Input URL: #{input_uri}")
      end

      case input_uri.scheme
      when 'http', 'https'
        Logglier::Client::HTTP.new(opts)
      when 'udp', 'tcp'
        Logglier::Client::Syslog.new(opts)
      else
        raise Logglier::UnsupportedScheme.new("#{input_uri.scheme} is unsupported")
      end
      
    end

    module InstanceMethods

      def massage_message(incoming_message, severity)
        outgoing_message = ""
        outgoing_message << "severity=#{severity}, "
        case incoming_message
        when Hash
          outgoing_message << incoming_message.map { |v| "#{v[0]}=#{v[1]}" }.join(", ")
        when String
          outgoing_message << incoming_message
        else
          outgoing_message << incoming_message.inspect
        end
        outgoing_message
      end

      def setup_input_uri(opts)
        @input_uri = opts[:input_url]

        begin
          @input_uri = URI.parse(@input_uri)
        rescue URI::InvalidURIError => e
          raise InputURLRequired.new("Invalid Input URL: #{@input_uri}")
        end
      end

    end

  end
end

require File.join(File.dirname(__FILE__), 'client', 'http')
require File.join(File.dirname(__FILE__), 'client', 'syslog')

