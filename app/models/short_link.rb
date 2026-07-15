# frozen_string_literal: true

class ShortLink < ApplicationRecord
  CODE_MIN_LENGTH = 7
  CODE_PATTERN = /\A[A-Za-z0-9]{#{CODE_MIN_LENGTH},}\z/
  ALPHABET = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'

  validates :original_url,
            http_url: true,
            presence: true,
            length: { maximum: 4096 }

  validates :code,
            uniqueness: true,
            format: { with: CODE_PATTERN },
            allow_nil: true

  after_create :update_code!

  def update_code!
    new_code = self.class.hashid.encode(id)
    update!(code: new_code)
    new_code
  end

  def self.decode(code)
    hashid.decode(code).first
  end

  def self.hashid
    @hashid ||= Hashids.new(Rails.application.credentials.hashid_salt, CODE_MIN_LENGTH, ALPHABET)
  end
end
