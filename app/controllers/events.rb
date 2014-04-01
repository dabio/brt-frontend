# encoding: utf-8

module Brt
  class Events < Boot

    def event
      @event ||= Event.first(date: params_date, slug: params[:slug]) || not_found
    end

    #
    # GET /rennen/[year]
    #
    get '/:year?' do |year|
      year ||= today.year
      events = Event.all(
        :is_hidden => false,
        :date.gte => Date.new(year, 1, 1),
        :date.lte => Date.new(year, 12, 31)
      ).group_by { |e| e.date.month }
      not_found unless events.length > 0

      erb :'events/index', locals: {
        events_by_month: events,
        title: "Rennkalender #{year}"
      }
    end

    #
    # GET /rennen/:year/:month/:day/:slug
    #
    get '/:year/:month/:day/:slug' do
      erb :'events/detail', locals: { event: event, title: event.title }
    end

  end
end
