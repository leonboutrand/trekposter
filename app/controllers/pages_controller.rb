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

  def global_coloring(markers)
    # noter chaque elevation sur 10? (tester différentes valeurs)
    # obtenir les distances entre chaque point avec racine lat long
    # ainsi obtenir la distance totale
    # chaque fois que color n'est pas pareil que le précedent {index: somme_current_dist / total, new color}
    # convertir cette note en couleur en fonction du color range
    
    color_bounds = [
      [255, 255, 0],
      [255, 0, 0]
    ]
    grad = 10
    color_range = (0..grad).map do |i|
      (0..2).map do |j|
        color_bounds[0][j] + i*(color_bounds[1][j]-color_bounds[0][j])/grad
      end
    end
    color_range.map! { |c| "rgb(#{c[0]},#{c[1]},#{c[2]})"}

    colors = []
    max_ele = markers.max {|a, b| a[:ele] <=> b[:ele]}[:ele]
    min_ele = markers.min {|a, b| a[:ele] <=> b[:ele]}[:ele]
    amp_ele = max_ele - min_ele

    if (amp_ele > 0)
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
          colors += [marker[:distance].fdiv(distance), color_range[marker[:color]]]
        end
        previous_color = marker[:color]
      end
    else
      markers.each do |marker|
        marker[:color] = 255
      end
      colors = [0, color_range[0], 1, color_range[0]]
    end
    colors
  end

  def color_markers
    
  end

  def main
    @markers = parseGPX
    puts "\n\n\n\n\n\n HEYYYYY"
    ap @route_colors = global_coloring(@markers)
  end
end
