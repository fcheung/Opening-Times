class SearchController < ApplicationController
  include Geokit::Geocoders
  include ParserUtils

  DISTANCES = [1, 2, 5, 10, 15, 20, 50]
  DISTANCE_DEFAULT = 15
  RESULTS_PER_PAGE = 10
  RESULTS_LIMIT = 30

# if no params then render nothing found
# if @t then find group
# if groups then render choose group
# if !groups then render nothing found
# lat, lng = get_from_lat_lat(q)
# find_service by_ lat lng (and group)
# if no services then render nothing found
#

  def index
    @distance = params[:distance].to_i
    @distance = DISTANCE_DEFAULT unless DISTANCES.index(@distance)

    @location = params[:location]
    l_lat, l_lng = extract_lat_lng(@location)
    logger.info "lat=#{l_lat}, lng=#{l_lng}"
    if l_lat && l_lng
      @location = Geokit::LatLng.new(l_lat, l_lng)
    end
    
    unless @location
      logger.info "geocoding"
      @location = MultiGeocoder.geocode(@location + ", UK")
    end

    @facilities = Facility.paginate(:all, :origin => @location, :within => @distance, :order => 'distance', :page => params[:page], :per_page => RESULTS_PER_PAGE, :total_entries => RESULTS_LIMIT)

    @status_manager = StatusManager.new

    respond_to do |format|
      format.html { render @facilities.empty? ? 'no_results' : 'index' }
      format.xml
      format.json { render :json => @facilities.to_json( :only => [:id,:slug,:name,:location,:address,:postcode,:lat,:lng]), :methods => [:to_param]  }
    end
  end

  def advanced
  end

end
