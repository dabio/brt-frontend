# encoding: utf-8

module Brt
  class Contact < Boot

    #
    # GET /kontakt
    # Shows the contact form.
    #
    get '/' do
      erb :'contact/index', locals: {
        email: Email.new, title: 'Kontakt', message: params.has_key?("success")
      }
    end

    #
    # POST /kontakt
    # Checks for valid form data and saves the email into the database. Sends
    # an email to the contact.
    #
    post '/' do
      redirect(to('/')) if params[:email].length > 0

      email = Email.new(params[:contact])
      if email.save
        redirect to('/?success=yes')
      else
        erb :'contact/index', locals: { email: email, title: 'Kontakt' }
      end
    end

  end
end
