# encoding: utf-8

module Brt
  class Team < Boot

    #
    # GET /team
    # Shows a list of all team members.
    #
    get '/' do
      erb :'team/index', locals: { people: Person.all }
    end

    #
    # GET /team/:slug
    # Show detailed information about a cyclist.
    #
    get '/:slug' do |slug|
      erb :'team/detail', locals: {
        person: person,
        participations: person.results_by_year
      }
    end

  end
end
