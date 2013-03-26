# encoding: utf-8

module ModuleName
  class App < Boot

    #
    # GET /
    #
    get '/' do
      erb :index
    end

  end
end
