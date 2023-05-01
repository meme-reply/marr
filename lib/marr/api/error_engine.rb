require 'active_support'
require 'marr/api/error'

module Marr
  module Api
    module ErrorEngine
      ::Marr::Api::Error.all_errors.each do |error|
        name = error[:name]
        namespace = error[:namespace]

        define_method "raise_#{name}".to_sym do |*args|
          api_error = "#{namespace}::#{name.camelcase}".constantize.new(args)

          raise api_error
        end
      end
    end
  end
end