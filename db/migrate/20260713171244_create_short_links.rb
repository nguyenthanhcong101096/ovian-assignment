# frozen_string_literal: true

class CreateShortLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :short_links do |t|
      t.text :original_url, null: false
      t.string :code

      t.timestamps
    end

    add_index :short_links, :code, unique: true
    add_index :short_links, :original_url
  end
end
