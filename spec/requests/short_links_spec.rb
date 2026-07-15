# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShortLinks' do
  describe 'GET /s/:code' do
    let(:original_url) { 'https://codesubmit.io/library/react' }

    it 'redirects to the original URL' do
      short_link = ShortLink.create!(original_url: original_url)

      get short_link_path(short_link.code)

      expect(response).to redirect_to(original_url)
    end

    it 'returns not found when the code does not exist' do
      get short_link_path('abcdefg')

      expect(response).to have_http_status(:not_found)
    end
  end
end
