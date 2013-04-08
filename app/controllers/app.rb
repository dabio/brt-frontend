# encoding: utf-8

module Brt
  class App < Boot

    #
    # GET /
    #
    get '/' do
      erb :index, locals: { news: News.all(limit: 8) }
    end

  end
end
