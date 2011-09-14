class User < ActiveRecord::Base  
  attr_accessible :username, :password, :password_confirmation, :bio
  attr_readonly :username
  
  has_many :stories, :order => "created_at DESC"
  has_many :comments, :order => "created_at DESC"
  has_many :own_categories, :class_name => "Category"
  
  has_secure_password
  
  validates :username, :uniqueness => { :case_sensitive => false },
    :length => { :in => 3..32 },
    :format => { :with => /\A[a-z0-9_]*\z/i, :message => 'may only contain alphanumeric characters and underscores' }
  validates :password, :length => { :minimum => 6 }, :if => lambda{ new_record? || password.present? }
  
  def posts
    (stories.limit(10) + comments.limit(10)).sort { |a,b| a.created_at <=> b.created_at }.reverse.take(10)
  end
  
  after_validation :remove_password_digest_error
  def remove_password_digest_error
    # this is a hacky way to remove the "password digest can't be blank" error
    errors[:password_digest].clear
  end
  
  before_create :set_points_to_zero
  def set_points_to_zero
    self.points = 0
  end
  
  def to_param
    username
  end
end
