require 'rubygems'

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'jse/version'

begin
  require 'cucumber'
  require 'cucumber/rake/task'

  namespace :cucumber do
    Cucumber::Rake::Task.new(:ok) do |t|
      t.cucumber_opts = "--format progress -t ~@wip -b"
    end

    Cucumber::Rake::Task.new(:wip) do |t|
      t.cucumber_opts = "--format pretty -t @wip"
    end
  end

  task :cucumber => 'cucumber:ok'
rescue LoadError
  desc 'Cucumber rake task not available'
  task :cucumber do
    abort 'Install cucumber as a gem to run tests.'
  end
end

begin
  require 'spec/rake/spectask'

  Spec::Rake::SpecTask.new(:spec) do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
  end
rescue LoadError
  desc 'RSpec rake task not available'
  task :spec do
    abort 'Install rspec as a gem to run tests.'
  end
end

task :default => [:spec, :cucumber]

desc 'Build the jse gem'
task :build do
  system "gem build jse.gemspec"
end

desc 'Push a the gem to gemcutter'
task :release => :build do
  system "gem push jse-#{JSE::VERSION}.gem"
end

desc 'Clean up old gems'
task :clean do
  system "rm *.gem"
end
