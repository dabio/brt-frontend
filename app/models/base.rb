# encoding: utf-8

class Base

  def editlink
    if new?
      self.class.link
    else
      "#{self.class.link}/#{id}"
    end
  end

  def deletelink
    "#{self.class.link}/#{id}"
  end

  class << self

    def link
      '/'
    end

    def createlink
      self.link
    end

  end
end
