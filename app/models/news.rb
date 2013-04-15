# encoding: utf-8

class News < Base
  include DataMapper::Resource

  property :id,       Serial
  property :date,     Date
  property :title,    String
  property :teaser,   Text
  property :message,  Text
  timestamps :at
  property :slug,       String

  belongs_to :person
  belongs_to :event, required: false

  default_scope(:default).update(order: [:date.desc, :updated_at.desc])

  def link
    [self.class.link, date.strftime('%Y/%m/%d'), slug].join('/')
  end

  def date_formatted(format='%-d. %B %Y')
    R18n::l(date, format)
  end

  def message_formatted
    markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      autolink: true,
      safe_links_only: true
    )
    markdown.render(message)
  end

  def self.link
    '/news'
  end

end
