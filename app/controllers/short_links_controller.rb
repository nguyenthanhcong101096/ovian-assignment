# frozen_string_literal: true

class ShortLinksController < ApplicationController
  def show
    short_link = ShortLink.find_by!(code: params.require(:code))

    redirect_to short_link.original_url, allow_other_host: true, status: :found
  end
end
