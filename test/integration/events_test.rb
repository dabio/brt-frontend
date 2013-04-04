require File.expand_path('../../helper', __FILE__)

context 'Events' do

  def app
    Brt::Events
  end

  setup do
    @today = Date.today
  end

  test '/' do
    get '/'
    assert last_response.ok?
    assert last_response.body.include?("Rennkalender #{@today.year.to_s}")
  end

  test '/2012' do
    get '/2012'
    assert last_response.ok?
    assert last_response.body.include?('Rennkalender 2012')
    assert last_response.body.include?('Velothon')
  end

  test '/2008' do
    get '/2008'
    assert last_response.ok?
    assert last_response.body.include?('Rennkalender 2008')
    assert last_response.body.include?('Cyclassics')
  end

  test 'years without event' do
    get '/2001'
    assert !last_response.ok?
  end

end
