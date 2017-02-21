# encoding: utf-8
# frozen_string_literal: true
module YardToDocset
  module Yard
    ##
    # Generates +Yard+ documentation from local ruby sources or through
    # gem download from rubygems.org.
    #
    # @example Yard generation through gem download
    #   dir = File.expand_path('~/downloads')
    #   YardToDocset::Yard.generate dir, gem: 'sequel'
    #
    # @example Yard generation from local sources
    #   dir = File.expand_path('~/downloads')
    #   YardToDocset::Yard.generate dir, sources: __dir__
    #
    # @exception DirectoryNotExists
    #   @see Yard#DirectoryNotExists
    #
    # @exception ParamsNotSpecified
    #   @see Yard#ParamsNotSpecified
    #
    # @param [String] path_to_yardoc
    #   Path where a folder with generated yard doc will be saved.
    #
    # @param [Hash] params
    # @option params [String] :gem (nil)
    #   When used it downloads gem from rubygems.org
    # @option params [String] :sources (nil)
    #   When used it generates yard docs from local code sources.

    def self.generate(path_to_yardoc, **params)
      if !File.directory?(path_to_yardoc)
        raise DirectoryNotExists, path_to_yardoc

      elsif !(params[:gem] || params[:sources])
        raise ParamsNotSpecified

      elsif params[:gem]
        download_from_rubygems params[:gem], path_to_yardoc

      elsif params[:sources]
        parse_sources params[:sources], path_to_yardoc
      end
    end

    # @param [String] gem_name
    # @param [String] path_to_yardoc

    def self.download_from_rubygems(gem_name, path_to_yardoc)
      direct_gem_download_url =
        begin
          url = "https://rubygems.org/api/v1/gems/%s.json" % gem_name.downcase
          response = send_request url

          JSON[response]["gem_uri"]
        end

      dir_with_sources_tmp =
        begin
          binary_data = send_request direct_gem_download_url
          dir_with_sources_tmp = Dir.mktmpdir
          Tempfile.create('gem') do |file|
            file.write binary_data
            gem = Gem::Package.new file.path
            gem.extract_files dir_with_sources_tmp
          end

          dir_with_sources_tmp
        end

      path_to_yardoc = File.join path_to_yardoc, gem_name
      parse_sources dir_with_sources_tmp, path_to_yardoc
      FileUtils.remove_entry_secure dir_with_sources_tmp
    end
    private_class_method :download_from_rubygems

    ##
    # Generates Yard documentation from ruby sources.
    #
    # @exception SourcesNotFound
    #   @see Yard#SourcesNotFound
    #
    # @param [String] path_to_sources
    # @param [String] path_to_yardoc

    def self.parse_sources(path_to_sources, path_to_yardoc)
      if !File.directory?(path_to_sources) || Dir.entries(path_to_sources) == [".", ".."]
        raise SourcesNotFound, path_to_sources
      end

      yardoc_cache_tmp_dir = Dir.mktmpdir
      YARD::CLI::Yardoc.run path_to_sources, "-o", path_to_yardoc, "-q", "-b", yardoc_cache_tmp_dir
      FileUtils.remove_entry_secure yardoc_cache_tmp_dir
    end
    private_class_method :parse_sources

    # @exception ConnectionError
    #   Raised when connection fails.
    #
    # @param [String] url
    #
    # @return [String]

    def self.send_request(url)
      response = Net::HTTP.get_response URI.parse(url)

      unless response.is_a? Net::HTTPSuccess
        raise ConnectionError.new response.code, response.message
      end

      return response.body
    end
    private_class_method :send_request

    ##
    # Exception raised when directory with sources not exists or empty.

    class SourcesNotFound < Error
      def initialize(directory); super "Directory with sources '#{directory}' not exists or empty!" end; end

    ##
    # Exception raised when Yard#generate_documentation called with invalid params.

    class ParamsNotSpecified < Error
      def initialize; super "Both: params[:gem_name] and params[:path_to_sources] not specified" end; end

    ##
    # Exception raised when directory not exists.

    class DirectoryNotExists < Error
      def initialize(directory); super "Directory '#{directory}' not exists!" end; end

    ##
    # Exception raised when connection fails.

    class ConnectionError < Error
      def initialize(code, message); super "Connection error! Code: '#{code}', Message: '#{message}'." end; end
  end # module Yard
end # module YardToDocset
