require File.expand_path('../../helper', __FILE__)

context 'Team' do

  def app
    Brt::Team
  end

  setup do; end

  test '/' do
    get '/'
    assert last_response.ok?
    assert last_response.body.include?('Team')
    assert last_response.body.include?('Danilo Braband')
  end

  test '/danilo-braband' do
    body = ['Danilo Braband', 'Ergebnisse', 'Cyclassics', 'Statistiken']
    get '/danilo-braband'
    assert last_response.ok?

    body.each do |text|
      assert last_response.body.include?(text)
    end
  end

end
