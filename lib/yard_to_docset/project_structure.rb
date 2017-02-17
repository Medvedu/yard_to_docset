# encoding: utf-8
# frozen_string_literal: true
module YardToDocset
  # === Dependencies from core lib

  require 'uri'
  require 'net/http'
  require 'json'
  require 'tempfile'
  require 'tmpdir'
  require 'rubygems/package'

  # === Dependencies from rubygems.org

  require 'yard'

  # === Project structure

  ##
  # Ancestor class for YardToDocset's exceptions.

  class Error < StandardError; end

  ##
  # Loads *.rb files in requested order.

  def self.load(**params)
    params[:files].each do |f|
      require File.join(__dir__, params[:folder].to_s, f)
    end
  end
  private_class_method :load

  # === Core

  load files: %w(rdoc)

  # === Command-Line-Interface

  load files: %w(cli)

end # module YardToDocset
