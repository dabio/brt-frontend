# encoding: utf-8

class Sponsor < Base
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String
  property :text,       Text
  property :image_url,  String
  property :url,        String
  timestamps :at

  default_scope(:default).update(order: [:title])

end
