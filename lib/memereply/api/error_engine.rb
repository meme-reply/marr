require 'active_support'
require 'memereply/api/error'

module Memereply
  module Api
    module ErrorEngine
      ::Memereply::Api::Error.all_errors.each do |error|
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