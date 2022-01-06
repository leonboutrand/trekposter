class PagesController < ApplicationController

  def parseGPX
    file = File.open('app/assets/gpx/sgmx.gpx')
    doc = Nokogiri::XML(open(file))
    trackpoints = doc.xpath('//xmlns:trkpt')
    trackpoints.map do |trkpt|
      [trkpt.xpath('@lat').to_s.to_f, trkpt.xpath('@lon').to_s.to_f, trkpt.xpath('ele').text.to_f]
    end
  end

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
