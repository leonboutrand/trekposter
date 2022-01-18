class PagesController < ApplicationController
  before_action :set_poster #, only: %I[show invite update_games]

  def set_poster
    @poster = {
      bounds: "",
      height: 600,
      width: 1000,
      padding: 10,
      background: 'linear-gradient(to right, #EEE, #BBB)',
      elevation_profile: true,
      elevation_color: '#336',
      elevation_height: 200,
      legend: {
        title: "Road trip 2022",
        subtitle: "VTT | Léon Boutrand",
        text_color: "red",
        position: 1,
        disposition: 1,
      }
    }
  end

  def parseGPX(file_url)
    file = File.open(file_url)
    doc = Nokogiri::XML(open(file))
    trackpoints = doc.xpath('//xmlns:trkpt')
    markers = trackpoints.map do |trkpt|
      {
        lat: trkpt.xpath('@lat').try(:to_s).try(:to_f),
        lng: trkpt.xpath('@lon').try(:to_s).try(:to_f),
        ele: trkpt.text.strip.to_f,
        ele2: trkpt.children[1].try(:text).try(:to_f)
      }
    end
    distance = 0
    previous_coord = [markers[0][:lat], markers[0][:lng]]
    markers.each do |marker|
      distance += Math.sqrt((marker[:lat] - previous_coord[0]) ** 2 + (marker[:lng] - previous_coord[1]) ** 2)
      marker[:distance] = distance
      previous_coord = [marker[:lat], marker[:lng]]
    end
    markers
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
        colors << []
        distance = markers[-1][:distance]
        previous_color = -1
        markers.each do |marker|
          marker[:color] = ((marker[:ele] - min_ele)*grad / amp_ele).to_i
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

  def elevation_path(markers_set)
    ele_margin = 40.0
    ele_height = @poster[:elevation_height]
    ele_width = @poster[:width] - 2 * @poster[:padding] - 10
    

    markers_set.each.with_index { |markers, i|
      if (i > 0)
        cumul = markers_set[i - 1][-1][:cumulated_distance]
        markers.each { |marker| marker[:cumulated_distance] = marker[:distance] + cumul }
      else
        markers.each { |marker| marker[:cumulated_distance] = marker[:distance] }
      end
    }
    flat_markers_set = markers_set.flatten
    max_ele = flat_markers_set.max {|a, b| a[:ele] <=> b[:ele]}[:ele]
    min_ele = flat_markers_set.min {|a, b| a[:ele] <=> b[:ele]}[:ele]
    amp_ele = max_ele - min_ele
    max_width = flat_markers_set[-1][:cumulated_distance]
    path = ["M", "0", ele_height, "L"]
    flat_markers_set.each do |marker|
      path += [
        marker[:cumulated_distance] * ele_width / max_width,
        ele_height - (ele_margin + (marker[:ele] - min_ele) * (ele_height - ele_margin) / amp_ele),
        "L"
      ]
    end
    path << [ele_width, ele_height, "Z"]
    path.join(" ")
  end

  def clean_markers(markers_set)
    length = markers_set.map(&:length).reduce(:+)
    max_points = 3000.0
    return if length < max_points
    points_to_delete = length - max_points
    markers_set.each do |markers|
      ptd = markers.length * points_to_delete / length
      indexes = (1..ptd).map { |i| (i * markers.length / ptd).to_i }.reverse
      indexes.each { |i| markers[i] = nil }
      markers.select! { |m| !m.nil? }
    end
  end

  def main
    urls = ['app/assets/gpx/3_0_0_Aix_Brian_on_par_Vars_et_Izoard.gpx', 'app/assets/gpx/sgmx.gpx','app/assets/gpx/sgmx2.gpx','app/assets/gpx/sgmx3.gpx']
    @markers = urls.map { |url| parseGPX(url) }
    clean_markers(@markers)
    @route_colors = global_coloring(@markers)
    @elevation_path = elevation_path(@markers)
  end
end
