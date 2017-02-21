# encoding: utf-8
# frozen_string_literal: true
module YardToDocset
module Docset
  class Parser
    # @return [Array<Array<String, String, String>>]

    attr_reader :records

    # @param [Docset::Constructor] constructor

    def initialize(constructor)
      @constructor = constructor
      @records = []
    end

    def parse
      parse_method_list
      parse_class_list
    end

    private

    def structure
      @constructor.structure
    end

    def parse_class_list
      doc = parse_document "class_list.html"

      # drop(1) since first element is always "Top Level Namespace" element
      doc.css('span.object_link').drop(1).each do |element|
        unparsed = element.children.first
        name = unparsed.children.first.to_s.gsub '#', ''
        path = structure.path_to_documents + unparsed["href"].to_s.encode('utf-8')

        @records << [name, 'Class', path.to_s]
      end
    end

    def parse_method_list
      doc = parse_document "method_list.html"

      doc.css('span.object_link').each do |element|
        unparsed = element.children.first
        name = unparsed["title"].to_s.gsub(/\((.+)\)/, '').strip
        path = structure.path_to_documents + unparsed["href"].to_s.encode('utf-8')

        @records << [name, 'Method', path.to_s]
      end
    end

    # @param [String] doc_name

    def parse_document(doc_name)
      path_to_doc = structure.path_to_documents + doc_name

      return Nokogiri::HTML(path_to_doc.read)
    end
  end # class Parser
end # module Docset
end # module YardToDocset
