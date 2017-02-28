class Visitor < ApplicationRecord
  belongs_to :property

  validates_presence_of :property
end
