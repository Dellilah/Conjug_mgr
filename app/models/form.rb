class Form < ActiveRecord::Base
  belongs_to :verb
  has_many :repetitions, :dependent => :destroy
  accepts_nested_attributes_for :verb
end
