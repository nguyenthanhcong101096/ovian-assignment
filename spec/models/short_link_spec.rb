# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShortLink, type: :model do
  let(:original_url) { 'https://codesubmit.io/library/react' }

  describe 'validations' do
    it 'is valid with an HTTP/HTTPS original URL' do
      expect(described_class.new(original_url: original_url)).to be_valid
    end

    it 'requires an original URL' do
      short_link = described_class.new(original_url: nil)

      expect(short_link).not_to be_valid
      expect(short_link.errors[:original_url]).to include("can't be blank")
    end

    it 'rejects a non-HTTP original URL' do
      short_link = described_class.new(original_url: 'javascript:alert(1)')

      expect(short_link).not_to be_valid
      expect(short_link.errors[:original_url]).to include('is not a valid HTTP/HTTPS URL')
    end

    it 'rejects an original URL longer than 4096 characters' do
      short_link = described_class.new(original_url: "https://example.com/#{'a' * 4077}")

      expect(short_link).not_to be_valid
      expect(short_link.errors[:original_url]).to include('is too long (maximum is 4096 characters)')
    end

    it 'allows a nil code before persistence' do
      short_link = described_class.new(original_url: original_url, code: nil)

      expect(short_link).to be_valid
    end

    it 'requires a unique code' do
      short_link = described_class.create!(original_url: original_url)
      duplicate = described_class.new(original_url: 'https://example.com/other', code: short_link.code)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:code]).to include('has already been taken')
    end
  end

  describe 'callbacks' do
    it 'generates and persists a code after create' do
      short_link = described_class.create!(original_url: original_url)

      expect(short_link.code).to eq(described_class.hashid.encode(short_link.id))
      expect(short_link.code).to match(described_class::CODE_PATTERN)
      expect(short_link.reload.code).to eq(short_link.code)
    end
  end
end
