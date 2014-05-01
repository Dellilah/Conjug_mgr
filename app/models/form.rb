class Form < ActiveRecord::Base
  belongs_to :verb
  has_many :repetitions
  accepts_nested_attributes_for :verb
end
