# encoding: utf-8

module ModuleName

  class Boot

    helpers Sinatra::RedirectWithFlash

    helpers do
      include Rack::Utils
      alias_method :h, :escape_html

      # This gives us the currently logged in user. We keep track of that by just
      # setting a session variable with their is. If it doesn't exist, we want to
      # return nil.
      def current_user
        unless @cp and @request.session[:user_id]
          @cp = User.get(@request.session[:user_id])
        end
        @cp
      end

      # Checks if this is a logged in user
      def has_auth?
        !current_user.nil?
      end
    end
  end
end
