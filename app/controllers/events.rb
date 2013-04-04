# encoding: utf-8

module Brt
  class Events < Boot

    #
    # GET /rennen/[year]
    #
    get '/:year?' do |year|
      year ||= today.year
      events = Event.all_for_year_by_month(year.to_i)
      not_found unless events.length > 0

      erb :'events/index', locals: { events_by_month: events }
    end

  end
end
