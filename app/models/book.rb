class Book < ActiveRecord::Base
  has_attached_file :asset, 
    {
      :styles => { :medium => ["300x300>", :png], :thumb => ["50x50>", :png] },
        :whiny => false
    }.merge(
    Settings.paperclip.storage == 's3' ?
    { :storage => Settings.paperclip.storage,
      :s3_credentials => Settings.paperclip.credentials,
      :path => Settings.paperclip.path,
      :bucket => Settings.paperclip.bucket} :
    {
      :storage => "filesystem"
    }
    )

  validates_presence_of :title
  belongs_to :user
  acts_as_taggable

  default_scope :order => "books.title ASC"

  def to_param
    "#{id}-#{title.gsub(/[^a-zA-Z0-9_-]/,'-').gsub(/-+/,'-')}"
  end

  #  attr_accessible :title, :notes, :tag_list, :asset
end
