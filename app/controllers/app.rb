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
      erb :'events/ics', layout: false, locals: { events: Event.all_for_year }
    end

  end
end
