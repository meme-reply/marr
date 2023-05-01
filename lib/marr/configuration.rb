class Configuration
  attr_accessor :namespaces, :trace_id_length, :custom_render

  def initialize
    @namespaces = []
    @trace_id_length = 8
    @custom_render = false
  end
end