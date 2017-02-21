# encoding: utf-8
# frozen_string_literal: true
module YardToDocset
module Docset
  class Constructor
    # @return [String]
    attr_reader :docset_name

    # @return [YardToDocset::Structure]

    attr_accessor :structure

    # @return [YardToDocset::Database]

    attr_accessor :database

    # @return [YardToDocset::Parser]

    attr_accessor :parser

    # @example Docset generation from local yard docs for sequel database.
    #   dir_to_dataset = File.expand_path(File.join(__dir__, '..', 'tmp'))
    #   dir_to_yardoc  = File.join(dir_to_dataset, 'sequel')
    #
    #   YardToDocset::Docset.generate dir_to_yardoc, dir_to_dataset
    #
    # @param [String] path_to_yardoc
    #   Path to original documentation.
    #
    # @param [String] path_to_docset
    #    Path where a folder with generated docset will be saved.
    #
    # @param [Hash] params
    # @option params [String] :docset_name (nil)
    #   Docset custom name. Optional.
    #
    # @return [Docset::Constructor]

    def initialize(path_to_yardoc, path_to_docset, **params)
      path_to_yardoc = Pathname.new(path_to_yardoc).expand_path

      @docset_name =
        params[:docset_name] || default_docset_name(path_to_yardoc)

      path_to_docset =
        Pathname.new(path_to_docset).expand_path + "#{docset_name}.docset"

      @structure = Structure.new path_to_yardoc, path_to_docset, self
      @parser    = Parser.new self
      @database  = Database.new self
    end

    def build_docset!
      structure.prepare!
      parser.parse
      database.seed
    end

    private

    # @param [Pathname] path_to_yardoc
    #
    # @return [String]

    def default_docset_name(path_to_yardoc)
      path_to_yardoc.each_filename.to_a.last.capitalize
    end
  end # class Constructor
end # module Docset
end # module YardToDocset
