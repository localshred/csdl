module CSDL
  class Error < ::StandardError; end

  class MissingChildNodesError < Error; end
  class InvalidInteractionTargetError < Error; end
  class InvalidQueryTargetError < Error; end
end
