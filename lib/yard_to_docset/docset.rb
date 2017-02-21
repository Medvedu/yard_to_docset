# encoding: utf-8
# frozen_string_literal: true
module YardToDocset
  module Docset
    ##
    # Generates docset for Dash from Yard.
    #
    # @exception DirectoryNotExists
    #   @see Docset#DirectoryNotExists
    #
    # @exception YardocNotFound
    #   @see Docset#YardocNotFound
    #
    # @param [String] path_to_yardoc
    #   Path to folder with yard documentation.
    #
    # @param [String] path_to_docset
    #   Path where a folder with generated docset doc will be saved.
    #
    # @param [Hash] params
    # @option params [String] :docset_name (nil)
    #   Docset name. Optional.

    def self.generate(path_to_yardoc, path_to_docset, **params)
      if !File.directory?(path_to_yardoc)
        raise YardocNotFound, path_to_yardoc

      elsif !File.directory?(path_to_yardoc)
        raise DirectoryNotExists, path_to_yardoc

      else
        constructor = Constructor.new path_to_yardoc, path_to_docset, params
        constructor.build_docset!
      end
    end

    ##
    # Exception raised when directory not exists.

    class DirectoryNotExists < Error
      def initialize(directory); super "Directory '#{directory}' not exists!" end; end

    ##
    # Exception raised when directory with yard docs not exists.

    class YardocNotFound < Error
      def initialize(directory); super "Directory with yard docs '#{directory}' not found!" end; end
  end # class module Docset
end # module YardToDocset
