begin
  desc 'Run all tests'
  require 'rake/testtask'
  Rake::TestTask.new do |t|
    t.libs << 'test'
    t.pattern = 'test/**/*_test.rb'
    t.verbose = true
  end
rescue LoadError
end

###############
# Development #
###############

desc "Same as rake watch"
task :default => :watch

desc 'Compile and run the site'
task :watch => [:install] do
  pids = [
    spawn('bundle exec shotgun'),
    spawn('bundle exec sass --style compressed --scss --watch public/css/master.scss')
  ]

  trap 'INT' do
    Process.kill 'INT', *pids
    exit 1
  end

  loop do
    sleep 1
  end
end

desc 'Start with foreman to emulate the provider'
task :foreman do
  `bundle exec foreman start`
end

desc 'Loads the latest database dump'
task :latest do
  %x(curl -o latest.dump `heroku pg:backups public-url --app brt-backend`)
  %x(pg_restore --verbose --clean --no-acl --no-owner -d brt latest.dump)
end

###############
# Un-/Install #
###############

desc 'Installs all dependencies for running locally'
task :install do
  `bundle install --binstubs vendor/bundle/bin --path vendor/bundle -j4 --without production`
end

desc 'Uninstalls all rubygems and temp files'
task :uninstall do
  rm_rf ['Gemfile.lock', 'vendor/', '.bundle/']
end
