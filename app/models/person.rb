# encoding: utf-8

class Person < Base
  include DataMapper::Resource

  property :id,         Serial
  property :first_name, String
  property :last_name,  String
  property :email,      String
  property :info,       Text, lazy: true
  timestamps :at
  property :slug,       String

  has n, :news
  has n, :participations
  has n, :events, through: :participations

  default_scope(:default).update(order: [:last_name, :first_name])

  def encrypted_email
    email.gsub(/@/, ' [at] ').gsub(/\./, ' . ')
  end

  def name
    "#{first_name} #{last_name}"
  end

  def link
    [self.class.link, slug].join('/')
  end

  def image_base_url
    "http://static.berlinracingteam.de#{link}"
  end

  def medium
    "#{image_base_url}_medium.jpg"
  end

  def results
    results ||= Participation.all(person: self, :date.lt => Date.today)
  end

  def results_by_year
    results.group_by { |r| r.date.year }
  end

  def total_distance
    results.inject(0) { |sum, r| sum + r.event.distance }
  end

  def total_distance_per_year(year=Date.today.year)
    results_by_year[year].inject(0) { |sum, r| sum + r.event.distance } 
  end

  def self.link
    '/team'
  end

end
