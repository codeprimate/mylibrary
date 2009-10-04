class User < ActiveRecord::Base
  acts_as_authentic
  has_many :books

  attr_accessible :username, :email, :password, :password_confirmation
end
