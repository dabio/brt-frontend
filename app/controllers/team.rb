# encoding: utf-8

module Brt
  class Team < Boot

    def person
      @person ||= Person.first(slug: params[:slug]) || not_found
    end

    #
    # GET /team
    # Shows a list of all team members.
    #
    get '/' do
      erb :'team/index', locals: { people: Person.all, title: 'Team' }
    end

    #
    # GET /team/:slug
    # Show detailed information about a cyclist.
    #
    get '/:slug' do |slug|
      erb :'team/detail', locals: {
        person: person, title: person.name, participations: person.results_by_year
      }
    end

  end
end
