# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      rescue_from ActionController::ParameterMissing, with: :render_bad_request
      rescue_from ApiError::InvalidParametersError, with: :render_bad_request
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid
      rescue_from ApiError::InternalServerError, with: :render_internal_server_error

      private

      def render_bad_request(error)
        render_error(
          error_code: :invalid_parameters,
          message: error.message,
          status: :bad_request
        )
      end

      def render_record_invalid(error)
        render_error(
          error_code: :invalid_parameters,
          message: error.record.errors.full_messages.join(', '),
          status: :unprocessable_content
        )
      end

      def render_not_found
        render_error(
          error_code: :not_found,
          message: 'Resource not found',
          status: :not_found
        )
      end

      def render_internal_server_error
        render_error(
          error_code: :internal_server_error,
          message: 'Internal server error',
          status: :internal_server_error
        )
      end

      def render_error(error_code:, message:, status:)
        render json: {
          error: {
            code: error_code,
            message: message
          }
        }, status: status
      end
    end
  end
end
