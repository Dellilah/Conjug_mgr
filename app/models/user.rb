class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :repetitions
  has_many :pgroups
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
