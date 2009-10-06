class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.integer :user_id
      t.string :title, :author, :publisher, :cached_tag_list
      t.text :notes
      t.date :year
      t.string :asset_file_name, :asset_content_type
      t.integer :asset_file_size
      t.datetime :asset_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :books
  end
end
