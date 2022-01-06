class PagesController < ApplicationController
  def main
    @markers = [{
      lat: 35,
      lng: 36
    },{
      lat: 37,
      lng: 36
    }]
  end
end
