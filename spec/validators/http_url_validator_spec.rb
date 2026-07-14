# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HttpUrlValidator do
  before do
    stub_const(
      'HttpUrlValidatorSpecRecord',
      Class.new do
        include ActiveModel::Model

        attr_accessor :url

        validates :url, http_url: true
      end
    )
  end

  describe '.compliant?' do
    it 'returns true for HTTP and HTTPS URLs with hosts' do
      expect(described_class.compliant?('http://example.com')).to be(true)
      expect(described_class.compliant?('https://example.com/path?query=1')).to be(true)
    end

    it 'returns false for non-HTTP URLs, relative paths, and malformed URLs' do
      invalid_urls = ['ftp://example.com', 'javascript:alert(1)', '/relative/path', 'http://']

      expect(invalid_urls.map { |url| described_class.compliant?(url) }).to all(be(false))
    end
  end

  describe '#validate_each' do
    it 'allows HTTP and HTTPS URLs' do
      expect(HttpUrlValidatorSpecRecord.new(url: 'http://example.com')).to be_valid
      expect(HttpUrlValidatorSpecRecord.new(url: 'https://example.com')).to be_valid
    end

    it 'rejects blank values' do
      record = HttpUrlValidatorSpecRecord.new(url: nil)

      expect(record).not_to be_valid
      expect(record.errors[:url]).to include('is not a valid HTTP/HTTPS URL')
    end

    it 'rejects invalid URLs' do
      record = HttpUrlValidatorSpecRecord.new(url: 'not-a-url')

      expect(record).not_to be_valid
      expect(record.errors[:url]).to include('is not a valid HTTP/HTTPS URL')
    end
  end
end
