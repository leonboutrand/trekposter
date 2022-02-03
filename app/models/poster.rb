class Poster < ApplicationRecord
  has_many :routes
  has_one :legend
end
