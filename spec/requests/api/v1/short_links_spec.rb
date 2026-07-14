# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::ShortLinks' do
  let(:original_url) { 'https://codesubmit.io/library/react' }
  let(:short_link_host) { 'example.com' }

  before do
    allow(Rails.application.credentials).to receive(:short_link_host).and_return(short_link_host)
  end

  describe 'POST /api/v1/encode' do
    subject(:perform_request) do
      post api_v1_encode_path, params: { original_url: original_url }
    end

    context 'when the original URL is valid' do
      it 'creates a short link and returns created status' do
        expect { perform_request }.to change(ShortLink, :count).by(1)
        expect(response).to have_http_status(:created)
      end

      it 'returns the shortened URL' do
        perform_request

        short_link = ShortLink.last
        expect(short_link.original_url).to eq(original_url)
        expect(response.parsed_body).to eq('short_url' => "https://#{short_link_host}/s/#{short_link.code}")
      end
    end

    context 'when original URL is invalid' do
      let(:original_url) { 'javascript:alert(1)' }

      it 'returns unprocessable content' do
        perform_request
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.parsed_body).to eq(
          'error' => {
            'code' => 'invalid_parameters',
            'message' => 'Original url is not a valid HTTP/HTTPS URL'
          }
        )
      end

      it 'does not create a short link' do
        expect { perform_request }.to change(ShortLink, :count).by(0)
      end
    end

    context 'when original URL is blank' do
      let(:original_url) { nil }

      it 'returns bad request' do
        perform_request
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body).to eq(
          'error' => {
            'code' => 'invalid_parameters',
            'message' => 'param is missing or the value is empty or invalid: original_url'
          }
        )
      end

      it 'does not create a short link' do
        expect { perform_request }.to change(ShortLink, :count).by(0)
      end
    end
  end

  describe 'GET /api/v1/decode' do
    subject(:perform_request) do
      get api_v1_decode_path, params: { short_url: short_url }
    end

    context 'when the short URL exists' do
      let!(:short_link) { ShortLink.create!(original_url: original_url) }
      let(:short_url) { "https://#{short_link_host}/s/#{short_link.code}" }

      it 'returns the original URL' do
        perform_request

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq(
          'original_url' => original_url
        )
      end
    end

    context 'when the short URL does not exist' do
      let(:short_url) { "https://#{short_link_host}/s/abcdefg" }

      it 'returns not found' do
        perform_request

        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body).to eq(
          'error' => {
            'code' => 'not_found',
            'message' => 'Resource not found'
          }
        )
      end
    end

    context 'when the short URL is wrong format' do
      let(:short_url) { 'not-a-url' }

      it 'returns bad request' do
        perform_request

        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body).to eq(
          'error' => {
            'code' => 'invalid_parameters',
            'message' => 'Short url is not a valid HTTP/HTTPS URL'
          }
        )
      end
    end
  end
end
