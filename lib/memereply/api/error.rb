require 'memereply/api/error/version'
require 'memereply/configuration'
require 'memereply/api_error'

module Memereply
  module Api
    module Error
      class << self 
        def configuration
          @configuration ||= Configuration.new
        end

        def configure
          yield(configuration)
          load 'memereply/api/error_engine'
        end

        def all_errors
          return [] if self.configuration.namespaces.blank?

          self.configuration.namespaces.map(&:constantize).map do |namespace|
            namespace.constants.map { |x| { namespace: namespace, name: x.to_s.underscore } }
          end
        end
      end 
    end
  end
end