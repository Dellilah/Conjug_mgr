class Verb < ActiveRecord::Base
  has_many :forms, :dependent => :destroy
  has_many :ugroups
  has_many :pgroups, :through => :ugroups
  validates :infinitive, uniqueness: true
end
