# encoding: utf-8

module Brt
  class NewsApp < Boot

    def news
      @news ||= News.first(date: params_date, slug: params[:slug]) || not_found
    end

    #
    # GET /news
    #
    get '/' do
      count, news = News.paginated(page: current_page, per_page: 10)
      erb :'news/index', locals: {
        news: news, page: current_page, page_count: count,
        title: 'Nachrichten &amp Rennberichte'
      }
    end

    #
    # GET /news/:year/:month/:day/:slug
    #
    get '/:year/:month/:day/:slug' do
      erb :'news/detail', locals: {
        news: news,
        title: news.title,
        og: {
          title: news.title,
          description: news.teaser,
          type: 'article',
          image: '/img/header.png'
        }
      }
    end

  end
end
