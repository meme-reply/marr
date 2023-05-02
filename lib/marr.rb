# frozen_string_literal: true
require 'active_support'
require 'json'
require 'securerandom'
require 'marr/configuration'
require 'marr/version'

module Marr
  autoload :Configuration,      'marr/configuration'
  autoload :ApiError,           'marr/api_error'

  module Api
    autoload :ErrorEngine,      'marr/api/error_engine'
  end

  class << self 
    def configuration
      @configuration ||= ::Marr::Configuration.new
    end

    def configure
      yield(configuration)
      load('lib/marr/api/error_engine.rb')
    end

    def all_errors
      return [] if self.configuration.namespaces.blank?

      self.configuration.namespaces.map(&:constantize).map do |namespace|
        namespace.constants.map { |x| { namespace: namespace, name: x.to_s.underscore } }
      end
    end

    def version
      ::Marr::VERSION
    end
  end 
end