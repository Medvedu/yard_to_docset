# encoding: utf-8
# frozen_string_literal: true
module YardToDocset
  module Yard
    ##
    # Generates +Yard+ documentation.
    #
    # @example Yard generation throw gem download
    #   dir = File.expand_path('~/downloads')
    #   YardToDocset::Yard.generate dir, gem_name: 'sequel'
    #
    # @exception DirectoryNotExists
    #   @see Yard#DirectoryNotExists
    # @exception ParamsNotSpecified
    #   @see Yard#ParamsNotSpecified
    #
    # @param [String] path_to_yardoc
    #   Path where generated Yard gonna be saved.
    #
    # @param [Hash] params
    # @option params [String] :gem_name (nil)
    #    When used it downloads gem from www.rubydoc.info.
    # @option params [String] :path_to_sources (nil)
    #   When used it generates Yard from code sources.

    def self.generate(path_to_yardoc, **params)
      if !File.directory?(path_to_yardoc)
        raise DirectoryNotExists, path_to_yardoc

      elsif !(params[:gem_name] || params[:path_to_sources])
        raise ParamsNotSpecified

      elsif params[:gem_name]
        download_from_rubydoc params[:gem_name], path_to_yardoc

      elsif params[:path_to_sources]
        parse_sources params[:path_to_sources], path_to_yardoc
      end
    end

    # @param [String] gem_name
    # @param [String] path_to_yardoc

    def self.download_from_rubydoc(gem_name, path_to_yardoc)
      direct_gem_download_url =
        begin
          url = "https://rubygems.org/api/v1/gems/%s.json" % gem_name.downcase
          response = send_request url

          JSON[response]["gem_uri"]
        end

      dir_with_sources =
        begin
          binary_data = send_request direct_gem_download_url
          dir_with_sources = Dir.mktmpdir
          Tempfile.create('gem') do |file|
            file.write binary_data
            gem = Gem::Package.new file.path
            gem.extract_files dir_with_sources
          end

          dir_with_sources
        end

      parse_sources dir_with_sources, path_to_yardoc
      FileUtils.remove_entry dir_with_sources
    end
    private_class_method :download_from_rubydoc

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

      YARD::CLI::Yardoc.run path_to_sources, "-o", path_to_yardoc, "-q"
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

      response.body
    end
    private_class_method :send_request

    ##
    # Exception raised when Yard#parse_sources called with dir without any files.

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
      def initialize(code, message); super "Connection refused by remote server. Error code: '#{code}', Exception message: '#{message}'." end; end
  end # module Yard
end # module YardToDocset
