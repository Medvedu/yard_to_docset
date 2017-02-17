# encoding: utf-8
# frozen_string_literal: true
#
# @title Yard to Dash Docset Converter.
#
# @see readme.md
#
# @authors Kuzichev Michael
# @license MIT
module YardToDocset
  require_relative 'yard_to_docset/project_structure'
end # module YardToDocset


dir = File.expand_path('~/downloads/sequel')
YardToDocset::Yard.generate dir, path_to_sources: dir
