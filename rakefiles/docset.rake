# encoding: utf-8
# frozen_string_literal: true
namespace :yard_to_docset do
  namespace :docset do
    desc 'Generate a docset for Dash from downloading YARD documentation' +
         'through rubygems.org service.'
    task :generate_from_yard, [:gem, :path] do |task, args|
      abort("Terminated! Gem name not specified!") unless args.any?

      begin
        require 'yard_to_docset'
      rescue LoadError
        require_relative '../lib/yard_to_docset'
      end

      begin
        puts "Task started"

        gem = args[:gem]
        path_to_docset = args[:path] || File.join(ENV["HOME"], 'docsets')

        tmpdir = Dir.mktmpdir
        YardToDocset::Yard.generate tmpdir, gem: gem
        YardToDocset::Docset.generate File.join(tmpdir, gem), path_to_docset

        puts "Task finished"
      rescue Exception => exception
        puts "RAKE TASK CRASHED! Exception message: #{exception.message}"

      ensure
        FileUtils.remove_entry_secure tmpdir
      end
    end
  end # namespace :docset
end # namespace :yard_to_docset
