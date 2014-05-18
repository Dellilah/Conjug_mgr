class Verb < ActiveRecord::Base
  has_many :forms
  validates :infinitive, uniqueness: true
end
