class Book < ActiveRecord::Base
  has_attached_file :asset, :styles => { :medium => ["300x300>", :png], :thumb => ["50x50>", :png] }

  validates_presence_of :title
  belongs_to :user
  acts_as_taggable

  default_scope :order => "books.title ASC"

  def to_param
    "#{id}-#{title.gsub(/[^a-zA-Z0-9_-]/,'-').gsub(/-+/,'-')}"
  end

#  attr_accessible :title, :notes, :tag_list, :asset
end
