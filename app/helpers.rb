# encoding: utf-8

module Brt

  class Boot

    helpers Sinatra::RedirectWithFlash

    helpers do
      include Rack::Utils
      alias_method :h, :escape_html

      # Returns the current page given by the url request parameter. Defaults to
      # 1.
      def current_page
        params[:page] && params[:page].match(/\d+/) ? params[:page].to_i : 1
      end

      def partial(template, locals={})
        erb :"_partials/#{template}", locals: locals
      end

      def params_date
        Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      end

      def static
        'http://static.berlinracingteam.de'
      end

      def today
        Date.today
      end

    end
  end
end
