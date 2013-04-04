require File.expand_path('../../helper', __FILE__)

context 'Contact' do

  def app
    Brt::Contact
  end

  setup do; end

  test '/' do
    get '/'
    assert last_response.ok?
    assert last_response.body.include?('Kontakt')
  end

end
