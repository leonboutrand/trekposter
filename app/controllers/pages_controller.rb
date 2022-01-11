class PagesController < ApplicationController

  def parseGPX(file_url)
    file = File.open(file_url)
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

  def global_coloring(markers_set)
    color_bounds = [
      [255, 255, 100],
      [50, 0, 0]
    ]
    grad = 10
    color_range = (0..grad).map do |i|
      (0..2).map do |j|
        color_bounds[0][j] + i*(color_bounds[1][j]-color_bounds[0][j])/grad
      end
    end
    color_range.map! { |c| "rgb(#{c[0]},#{c[1]},#{c[2]})"}

    colors = []
    max_ele = markers_set.flatten.max {|a, b| a[:ele] <=> b[:ele]}[:ele]
    min_ele = markers_set.flatten.min {|a, b| a[:ele] <=> b[:ele]}[:ele]
    amp_ele = max_ele - min_ele

    if (amp_ele > 0)
      markers_set.each.with_index do |markers, i|
        ap [markers.length, i]
        colors << []
        distance = 0
        previous_coord = [markers[0][:lat], markers[0][:lng]]
        markers.each do |marker|
          distance += Math.sqrt((marker[:lat] - previous_coord[0]) ** 2 + (marker[:lng] - previous_coord[1]) ** 2)
          marker[:color] = ((marker[:ele] - min_ele)*grad / amp_ele).to_i
          marker[:distance] = distance
          previous_coord = [marker[:lat], marker[:lng]]
        end
        previous_color = -1
        markers.each do |marker|
          if previous_color != marker[:color]
            colors[i] += [marker[:distance].fdiv(distance), color_range[marker[:color]]]
          end
          previous_color = marker[:color]
        end
      end
    else
      colors = [[0, color_range[0], 1, color_range[0]]]
    end
    colors
  end

  def main
    urls = ['app/assets/gpx/sgmx.gpx','app/assets/gpx/sgmx2.gpx']
    @markers = urls.map { |url| parseGPX(url) }
    @route_colors = global_coloring(@markers)
  end
end
