# frozen_string_literal: true

module Api
  module V1
    class ShortLinksController < BaseController
      def show
        short_url = params.require(:short_url).strip
        validator = DecodeShortLinkValidator.new(short_url: short_url)

        raise ApiError::InvalidParametersError, validator.errors.full_messages.join(', ') if validator.failure?

        short_link_id = ShortLink.decode(validator.code)

        raise ActiveRecord::RecordNotFound if short_link_id.blank?

        short_link = ShortLink.find(short_link_id)

        render json: {
          original_url: short_link.original_url
        }
      end

      def create
        orignal_url = params.require(:orignal_url).strip
        short_link  = ShortLink.create!(original_url: orignal_url)

        render json: {
          short_url: short_link_url(
            code: short_link.code,
            host: Rails.application.credentials.short_link_host,
            protocol: 'https',
            port: nil
          )
        }, status: :created
      end
    end
  end
end
