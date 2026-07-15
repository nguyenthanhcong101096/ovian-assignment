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

    unless allowed_host?(uri)
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

  private

  def allowed_host?(uri)
    host = Rails.application.credentials.short_link_host

    uri.host == host || uri_host_with_port(uri) == host
  end

  def uri_host_with_port(uri)
    return uri.host if uri.port == uri.default_port

    "#{uri.host}:#{uri.port}"
  end
end
