class PagesController < ApplicationController

  def parseGPX
    file = File.open('app/assets/gpx/sgmx.gpx')
    doc = Nokogiri::XML(open(file))
    trackpoints = doc.xpath('//xmlns:trkpt')
    trackpoints.map do |trkpt|
      {
        lat: trkpt.xpath('@lat').try(:to_s).try(:to_f),
        lng: trkpt.xpath('@lon').try(:to_s).try(:to_f),
        ele: trkpt.children[1].try(:text).try(:to_f)
      }
    end
  end

  def main
    @markers = parseGPX
    ap max_ele = @markers.max {|a, b| a[:ele] <=> b[:ele]}[:ele]
    ap min_ele = @markers.min {|a, b| a[:ele] <=> b[:ele]}[:ele]
    amp_ele = max_ele - min_ele
    if (amp_ele > 0)
      @markers.each do |gpx|
        gpx[:color] = ((gpx[:ele] - min_ele)*255 / amp_ele).to_i
      end
    else
      @markers.each do |gpx|
        gpx[:color] = 255
      end
    end
  end
end
