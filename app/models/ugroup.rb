class Ugroup < ActiveRecord::Base
  belongs_to :pgroup
  belongs_to :verb
end
