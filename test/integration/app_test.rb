require File.expand_path('../../helper', __FILE__)

context 'App' do

  def app
    ModuleName::App
  end

  setup do; end

  test '/' do
    get '/'
    assert last_response.ok?
  end

end
