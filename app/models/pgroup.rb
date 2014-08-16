class Pgroup < ActiveRecord::Base
  belongs_to :user
  has_many :ugroups
  has_many :verbs, :through => :ugroups
end
