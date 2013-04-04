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
    require 'net/smtp'

    opts[:to]       ||= ENV['EMAIL_TO']
    opts[:from]     ||= "#{name} <#{email}>"
    opts[:server]   ||= ENV['EMAIL_SERVER']
    opts[:port]     ||= ENV['EMAIL_PORT']
    opts[:user]     ||= ENV['EMAIL_USERNAME']
    opts[:password] ||= ENV['EMAIL_PASSWORD']

    msg = <<END_OF_MESSAGE
From: #{opts[:from]}
To: <#{opts[:to]}>
Subject: Nachricht von berlinracingteam.de

#{message}
END_OF_MESSAGE

    Net::SMTP.start(opts[:server], opts[:port], opts[:from], opts[:user], opts[:password], :plain) do |smtp|
      smtp.send_message msg, opts[:from], opts[:to]
    end
  end

end
