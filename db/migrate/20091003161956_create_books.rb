class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.string :title, :author
      t.text :notes
      t.integer :user_id
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
