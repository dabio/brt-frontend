# encoding: utf-8

class Email < Base
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String, required: true,
    messages: {
      presence: 'Bitte gib Deinen Namen an, damit wir Dich ansprechen können.'
    }
  property :email,      String, required: true, :format => :email_address,
    messages: {
      presence: 'Wir möchten Dir gerne antworten und benötigen daher deine E-Mail.',
      format: 'Deine E-Mail scheint nicht korrekt zu sein.'
    }
  property :message,    Text, required: true,
    messages: {
      presence: 'Du hast Deine Nachricht nicht eingetragen.'
    }
  property :send_at,    DateTime
  timestamps :at

  before :save do |e|
    e.send_at = Time.now
    e.send_email
  end

  def self.link
    '/kontakt'
  end

  def send_email(opts={})
    mail = SendGrid::Mail.new do |m|
      m.to = ENV['EMAIL_TO']
      m.from = "#{name} <#{email}>"
      m.subject = 'Nachricht von berlinracingteam.de'
      m.text = message
    end
    SendGrid::Client.new(api_key: ENV['SENDGRID_KEY']).send(mail)
  end

end
