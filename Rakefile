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

task :env do
  require './app/boot'
end

desc 'Compile and run the site'
task :default do
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

desc 'Open an irb session preloaded with this library'
task :console do
  `irb -rubygems -r ./app/boot`
end

###############
# Un-/Install #
###############

desc 'Installs all dependencies for running locally'
task :install do
  `bundle install --binstubs --path vendor/gems --without production`
end

desc 'Uninstalls all rubygems and temp files'
task :uninstall do
  rm_rf ['Gemfile.lock', 'vendor/', 'bin/', '.bundle/']
end

desc 'Start with foreman to emulate the provider'
task :foreman do
  `bundle exec foreman start`
end

task :load_migrations => :env do
  require 'dm-migrations'
  require 'dm-migrations/migration_runner'
  FileList['app/migrations/*.rb'].each do |migration|
    load migration
  end
end

namespace 'db' do

  task :migrate => :load_migrations do |t|
    puts '=> Migrating up'
    migrate_up!
    puts "<= #{t.name} done"
  end

  task :migrations => :load_migrations do
    puts migrations.sort.reverse.map {|m| "#{m.position}  #{m.name}  #{m.needs_up? ? '' : 'APPLIED'}"}
  end

end
