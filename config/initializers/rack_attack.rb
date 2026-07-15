# frozen_string_literal: true

Rack::Attack.cache.store = Rails.env.test? ? ActiveSupport::Cache::MemoryStore.new : Rails.cache

Rack::Attack.throttle('limit_number_to_create_short_url', limit: 10, period: 1.minute) do |request|
  request.ip if request.post? && request.path == '/api/v1/encode'
end

Rack::Attack.throttled_responder = lambda do |_request|
  [
    429,
    { 'Content-Type' => 'application/json' },
    [{ error: 'You are doing it too quick. Please try again later' }.to_json]
  ]
end
