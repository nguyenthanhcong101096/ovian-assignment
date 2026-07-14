# frozen_string_literal: true

class DecodeShortLinkValidator < ApplicationValidator
  attribute :short_url

  validates :short_url, presence: true, http_url: true
  validate :validate_short_url

  attr_reader :code

  private

  def validate_short_url
    return if short_url.blank?
    return unless HttpUrlValidator.compliant?(short_url)

    uri = URI.parse(short_url)

    unless uri.host == Rails.application.credentials.short_link_host
      errors.add(:short_url, 'has an invalid host')
      return
    end

    extracted_code = uri.path.delete_prefix('/s/')

    unless uri.path == "/s/#{extracted_code}" && ShortLink::CODE_PATTERN.match?(extracted_code)
      errors.add(:short_url, 'has an invalid format')
      return
    end

    @code = extracted_code
  end
end
