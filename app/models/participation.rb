# encoding: utf-8

class Participation < Base
  include DataMapper::Resource

  property :person_id,          Integer, key: true
  property :event_id,           Integer, key: true
  property :position_overall,   Integer
  property :position_age_class, Integer
  # this property is needed only for ordering the participation on the person
  # detail view
  property :date,               Date
  timestamps :at

  belongs_to :person, key: true
  belongs_to :event,  key: true

  before :save do |p|
    # this hook adds the event date to this participation. this is needed to
    # order the participations on a person detailed page.
    p.date = p.event.date
  end

  default_scope(:default).update(order: [:date.desc, :position_overall])

end
