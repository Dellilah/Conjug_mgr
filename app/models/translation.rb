class Translation < ActiveRecord::Base
  belongs_to :verb
  belongs_to :user
end
