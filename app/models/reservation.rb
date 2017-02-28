class Reservation < ApplicationRecord
	enum status: [ :pending, :active, :finished, :paid, :canceled ]

	belongs_to :property
	belongs_to :user

	validates_presence_of :property, :user

	def evaluate comment, new_rating
		Reservation.transaction do 
			property = self.property

			Comment.create(property: property, body: comment, user: self.user)

			quantity = property.reservations.where(evaluation: true).count
			property.rating = 0.0 if property.rating.nil?   
			property.rating = (((property.rating * quantity) + new_rating) / (quantity + 1))
			property.save!

			self.evaluation = true
			self.save! 
		end
	end
end
