# frozen_string_literal: true
require 'json'
require 'securerandom'

module Marr
  class ApiError < StandardError
    attr_accessor :resource, :object, :request, :response, :add_context, :add_error_context

    def initialize(attributes={})
      @controller = attributes[:controller]
      @object = attributes[:object]
      @resource = attributes[:resource] || 'Resource'
      @subcode = attributes[:subcode]
      @override_detail = attributes[:override_detail]
      @override_status = attributes[:override_status]
      @add_context = attributes[:add_context] || {}
      @add_error_context = attributes[:add_error_context] || {}
      @request = @controller.try(:request)
      @response = @controller.try(:response)
      set_resource
    end

    # Error name => code
    # Status => status
    # Subcodes => title
    # message => detail
    def object_errors
      return [] unless @object.present?
      return [] unless @object&.errors&.full_messages.present?

      attributes = @object.errors.details.map(&:first)
      @object_errors = []

      attributes.each do |attrb|
        @object.errors.full_messages_for(attrb).each do |msg|
          error = { pointer: attrb.to_s }
          error_with_message = error.merge(detail: msg)

          @object_errors << error_with_message
        end
      end
      @object_errors
    end

    def status(status: 422)
      @override_status&.integer? ? @override_status : status
    end

    def message
      raise NotImplementedError, 'Message must be implemented. Add Error message method.'
    end

    def subcodes(hash=nil)
      return {} if hash.blank

      hash.with_indifferent_access
    end

    def subcode
      return '' unless subcodes[@subcode].present?

      @subcode.to_s.camelcase
    end

    def detail
      return '' unless @override_detail.present? || subcodes[@subcode].present?

      @override_detail.present? ? override_detail : subcodes[@subcode]
    end

    def trace_id
      trace_id ||= SecureRandom.hex(trace_id_length).upcase
    end

    def type
      self.class.name.split('::').last
    end

    def render
      if Marr::Api::Error.configuration.custom_render
        custom_render
      else
        default_render.to_json
      end
    end

    def custom_render
      if Marr::Api::Error.configuration.custom_render
        raise NotImplementedError, 'Message must be implemented. Add Error message method.'
      else
        nil
      end
    end

    def default_render
      {
        errors: {
          code: type,
          title: subcode,
          detail: message,
          meta: {
            object_errors: object_errors,
            trace_id: trace_id,
          }
        }.merge(add_error_context)
      }.merge(add_context)
    end

    private

    def trace_id_length
      Marr::Api::Error.configuration.trace_id_length / 2
    end

    def set_resource
      return unless @object.present?
      return unless @object.errors&.full_messages.present?

      @resource = @object.class.name.split('::').last if @resource == 'Resource'
    end
  end
end
