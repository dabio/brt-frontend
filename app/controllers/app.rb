# encoding: utf-8

module Brt
  class App < Boot

    #
    # GET /
    #
    get '/' do
      erb :index
    end

  end
end
