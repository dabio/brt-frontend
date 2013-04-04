# encoding: utf-8

module Brt
  class NewsApp < Boot

    #
    # GET /news
    #
    get '/' do
      count, news = News.paginated(page: current_page, per_page: 20)
      erb :'news/index', locals: {
        news: news, page: current_page, page_count: count
      }
    end

    #
    # GET /news/:year/:month/:day/:slug
    #
    get '/:year/:month/:day/:slug' do
      erb :'news/detail', locals: { news: news }
    end

  end
end
