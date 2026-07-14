# frozen_string_literal: true

class ApiError < StandardError
  class InternalServerError < ApiError
  end

  class InvalidParametersError < ApiError
  end
end
