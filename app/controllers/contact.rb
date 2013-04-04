# encoding: utf-8

module Brt
  class Contact < Boot

    #
    # GET /kontakt
    # Shows the contact form.
    #
    get '/' do
      erb :'contact/index', locals: { email: Email.new }
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
        p email.name
        redirect to('/'), success: "#{email.name}, vielen Dank für deine Nachricht! Wir werden sie so schnell wie möglich beantworten."
      else
        erb :'contact/index', locals: { email: email }
      end
    end

  end
end
