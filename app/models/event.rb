# encoding: utf-8

class Event < Base
  include DataMapper::Resource

  property :id,       Serial
  property :date,     Date
  property :title,    String
  property :url,      String
  property :distance, Integer
  property :is_hidden,Boolean
  timestamps :at
  property :slug,     String

  belongs_to :person
  has 1, :news
  has n, :participations
  has n, :people, through: :participations

  default_scope(:default).update(order: [:date, :updated_at.desc])

  def link
    if news
      news.link
    else
      [self.class.link, date.strftime('%Y/%m/%d'), slug].join('/')
    end
  end

  def date_formatted(format='%-d. %B %Y')
    R18n::l(date, format)
  end

  class << self

    def link
      '/rennen'
    end

  end

end
