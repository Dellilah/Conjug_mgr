class Repetition < ActiveRecord::Base
  belongs_to :form
  belongs_to :user

  # before_create :set_last_to_now

  # def set_last_to_now
  #   self.last = Time.now
  # end

end
