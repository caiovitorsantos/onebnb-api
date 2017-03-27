class Reservation < ApplicationRecord
	enum status: [ :pending, :active, :finished, :paid, :canceled ]

	belongs_to :property
	belongs_to :user
	has_many :talks

	validates_presence_of :property, :user

	before_create :set_pending_status

	def set_pending_status
		self.status ||= :pending
	end

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

	def interval_of_days
		(self.checkout_date - self.checkin_date).to_i
	end
end
