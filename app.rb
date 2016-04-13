require "tilt/erb"
require "./lib/models"

class BRT < Sinatra::Base

  register Sinatra::R18n

  configure do
    disable :sessions

    set :default_locale, 'de'
  end

  helpers do

    def active_page
      @ap ||= request.path.split('/').delete_if(&:empty?).first || 'home'
    end

    def pages
      ['rennen', 'team', 'kontakt']
    end

    def params_date
      Date.new(
        params[:year].to_i,
        params[:month].to_i,
        params[:day].to_i
      )
    end

    def partial(template, locals={})
      erb :"_partials/#{template}", locals: locals
    end

    def today
      Date.today
    end
  end

  get "/" do
    erb :index
  end

  get "/rennen.ics" do
    #content_type "test/calendar"
  end

  get "/rennen/?:year?" do |year|
    year ||= today.year

    events = Event.where(
      is_hidden: false,
      date: (Date.new(year.to_i, 1, 1)..(Date.new(year.to_i, 12,31)))
    ).group(Sequel.function(:date_trunc, "'month'", :date))

    #not_found unless events.count > 0
    erb :events, locals: {
      title: "Rennkalender #{year}",
      events_by_month: events
    }
  end

  get "/rennen/:year/:month/:day/:slug" do
    event = Event.first(
      date: params_date, slug: params[:slug]
    ) || not_found

    erb :event, locals: {
      title: event.title,
      event: event
    }
  end

#  get "/news" do
#  end
#
#  get "/news/:year/:month/:day/:slug" do
#  end

  get "/team" do
  end

  get "/team/:slug" do |slug|
    person = Person.first(slug: slug) || not_found

    erb :person, locals: {
      title: person.name,
      person: person,
      participations: person.results_by_year
    }
  end

  get "/kontakt" do

  end

  post "/kontakt" do
  end

end
