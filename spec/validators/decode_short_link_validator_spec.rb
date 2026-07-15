# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DecodeShortLinkValidator do
  let(:short_link_host) { 'example.com' }
  let(:code) { 'abc123Z' }

  before do
    allow(Rails.application.credentials).to receive(:short_link_host).and_return(short_link_host)
  end

  describe '#valid?' do
    it 'accepts a short URL with the configured host and valid code path' do
      validator = described_class.new(short_url: "https://#{short_link_host}/s/#{code}")

      expect(validator).to be_valid
      expect(validator.code).to eq(code)
    end

    it 'requires a short URL' do
      validator = described_class.new(short_url: nil)

      expect(validator).not_to be_valid
      expect(validator.errors[:short_url]).to include("can't be blank")
      expect(validator.code).to be_nil
    end

    it 'rejects a non-HTTP short URL' do
      validator = described_class.new(short_url: 'not-a-url')

      expect(validator).not_to be_valid
      expect(validator.errors[:short_url]).to include('is not a valid HTTP/HTTPS URL')
      expect(validator.code).to be_nil
    end

    it 'rejects a short URL with a host that does not match credentials' do
      validator = described_class.new(short_url: "https://another.example/s/#{code}")

      expect(validator).not_to be_valid
      expect(validator.errors[:short_url]).to include('has an invalid host')
      expect(validator.code).to be_nil
    end

    it 'rejects a short URL with an invalid code' do
      invalid_codes = %w[abc123 abc-123]

      invalid_codes.each do |invalid_code|
        validator = described_class.new(short_url: "https://#{short_link_host}/s/#{invalid_code}")

        expect(validator).not_to be_valid
        expect(validator.errors[:short_url]).to include('has an invalid format')
        expect(validator.code).to be_nil
      end
    end
  end
end
