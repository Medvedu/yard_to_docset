# # encoding: utf-8
# # frozen_string_literal: true
# namespace :yard_to_docset do
#   namespace :development do
#     desc ["Creates sqlite3 database prototype.",
#           "Details: https://kapeli.com/docsets#createsqlite"].join "\n"
#     task :generate_template_sqlite3_db do
#       require 'sqlite3'
#
#       path_to_db_template =
#         File.join(Rake.application.original_dir, 'lib', 'resources', 'db.template')
#
#       if File.exist?(path_to_db_template)
#         abort "Task terminated! Database template already created!"
#       end
#
#       db = SQLite3::Database.new path_to_db_template
#       db.execute(
#         'CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type	TEXT, path TEXT)')
#     end
#
#
#     desc ["Download info.plist file",
#           "Details: https://kapeli.com/docsets#infoplist"].join "\n"
#     task :download_info_plist do
#       require 'net/http'
#
#       path_to_info_plist =
#         File.join(Rake.application.original_dir, 'lib', 'resources', 'info.plist')
#
#       if File.exist?(path_to_info_plist)
#         abort "Task terminated! Info.plist already loaded!"
#       end
#
#       body =
#         begin
#           url = "https://kapeli.com/resources/Info.plist"
#           response = Net::HTTP.get_response URI.parse(url)
#           unless response.is_a? Net::HTTPSuccess
#             abort "Task terminated with connection error! Error message: #{message}"
#           end
#
#           response.body
#         end
#
#       file = File.new(path_to_info_plist, 'w+')
#       file.write body
#       file.close
#     end
#   end # namespace :development
# end # namespace :yard_to_docset
