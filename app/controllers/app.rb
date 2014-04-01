# encoding: utf-8

module Brt
  class App < Boot

    #
    # GET /
    #
    get '/' do
      erb :index, locals: { news: News.all(limit: 8) }
    end


    get '/rennen.ics' do
      content_type 'text/calendar'
      erb :'events/ics', layout: false, locals: {
        events: Event.all(
          :date.gte => Date.new(Date.today.year, 1, 1),
          :date.lte => Date.new(Date.today.year, 12, 31)
        )
      }
    end

  end
end
