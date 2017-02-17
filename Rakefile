# encoding: utf-8
require 'bundler'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new
task default: :spec

Dir.glob(File.join(__dir__, 'rakefiles', '**/*')).each do |file|
  import file if File.extname(file) == '.rake'
end
