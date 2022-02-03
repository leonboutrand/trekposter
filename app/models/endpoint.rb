class Endpoint < ApplicationRecord
  enum position: [ :left, :top, :right, :down ]
  belongs_to :route
end
