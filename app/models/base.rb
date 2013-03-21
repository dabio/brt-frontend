# encoding: utf-8

class Base

  def editlink
    [link, 'edit'].join('/')
  end

  def link
    [self.class.link, id].join('/')
  end

  def deletelink
    link
  end

  def savelink
    link
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
