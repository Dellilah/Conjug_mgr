class Verb < ActiveRecord::Base
  has_many :forms, :dependent => :destroy
  validates :infinitive, uniqueness: true
end
