class Talk < ApplicationRecord

	belongs_to :user
	belongs_to :property
	belongs_to :reservation
	has_many :messages

	validates_presence_of :user, :property
end
