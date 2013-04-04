require File.expand_path('../../helper', __FILE__)

context 'NewsApp' do

  def app
    Brt::NewsApp
  end

  setup do; end

  test '/' do
    get '/'
    assert last_response.ok?
    assert last_response.body.include?('Nachrichten &amp; Rennberichte')
  end

end
