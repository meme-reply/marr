require 'marr/api/error/version'
require 'marr/configuration'
require 'marr/api_error'

module Marr
  module Api
    module Error
      class << self 
        def configuration
          @configuration ||= Configuration.new
        end

        def configure
          yield(configuration)
          load 'marr/api/error_engine'
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