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

      def partial(template)
        erb :"_partials/#{template}"
      end

      def person
        @person ||= Person.first(slug: params[:slug]) || not_found
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
