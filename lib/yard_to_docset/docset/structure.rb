# encoding: utf-8
# frozen_string_literal: true
module YardToDocset
module Docset
  class Structure
    # @return [Pathname]
    #   @see Docset::Constructor#initialize
    attr_reader :path_to_yardoc

    # @return [Pathname]
    #   @see Docset::Constructor#initialize
    attr_reader :path_to_docset

    # @return [Pathname]
    #  Alias for path_to_docset + "Contents"
    attr_reader :path_to_contents

    # @return [Pathname]
    #  Alias for path_to_docset + "Contents/Resources"
    attr_reader :path_to_resources

    # @return [Pathname]
    #   Alias for path_to_docset + "Contents/Resources/Document
    attr_reader :path_to_documents

    # @return [Pathname]
    #   Alias for path_to_docset + "Contents/Resources/docSet.dsidx"
    attr_reader :path_to_database

    # @return [Pathname]
    #   Alias for path_to_docset + "Contents/Info.plist"
    attr_reader :path_to_info_plist

    # @return [Pathname]
    #   Alias for path_to_docset + "meta.json"
    attr_reader :path_to_meta

    # @param [Docset::Constructor] constructor
    #
    # @param [Pathname] path_to_yardoc
    # @param [Pathname] path_to_docset
    #
    # @return [Docset::Structure]

    def initialize(path_to_yardoc, path_to_docset, constructor)
      @constructor    = constructor
      @path_to_yardoc = path_to_yardoc
      @path_to_docset = path_to_docset

      @path_to_contents  = path_to_docset    + "Contents"
      @path_to_resources = path_to_contents  + "Resources"
      @path_to_documents = path_to_resources + "Documents"

      @path_to_database   = path_to_resources + "docSet.dsidx"
      @path_to_info_plist = path_to_contents  + "Info.plist"

      @path_to_meta = path_to_docset + 'meta.json'

      @path_to_resources =
        Pathname.new(File.join(__dir__, '../' * 2, 'resources',))
    end

    def prepare!
      recreate_folder!

      copy_yardoc_files
      copy_info_plist
      copy_meta_file
      copy_icons

      fix_css_for_yard_0_9_and_higher
    end

    private

    # @return [Docset::Constructor]

    attr_reader :constructor

    # @return [Pathname]
    #   Alias for "../lib/resources"
    attr_reader :path_to_resources

    def recreate_folder!
      path_to_docset.rmtree if path_to_docset.exist?
      path_to_documents.mkpath
    end

    def copy_yardoc_files
      FileUtils.cp_r path_to_yardoc.to_s + "/.", path_to_documents.to_s
    end

    def copy_info_plist
      path_to_info_plist_origin = path_to_resources + 'info.plist'
      data = path_to_info_plist_origin.read % [constructor.docset_name,
                                               constructor.docset_name,
                                               constructor.docset_name]
      path_to_info_plist.write data
    end

    def copy_meta_file
      path_to_meta_origin = path_to_resources + 'meta.json'
      data = path_to_meta_origin.read % [constructor.docset_name,
                                         constructor.docset_name]
      path_to_meta.write data
    end

    def copy_icons
      FileUtils.cp path_to_resources + 'icon.png',    path_to_docset
      FileUtils.cp path_to_resources + 'icon@2x.png', path_to_docset
    end

    def fix_css_for_yard_0_9_and_higher
      path_to_css_fix = path_to_resources + 'yard_css_fix.fix'
      fix = path_to_css_fix.read

      File.open(path_to_documents + 'css/style.css', 'a') { |f| f.write fix }
    end
  end # class Structure
end # module Docset
end # module YardToDocset
