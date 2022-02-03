class Route < ApplicationRecord
  mount_uploader :gpx_track, GpxTrackUploader
  has_many :endpoints
  belongs_to :poster
end
