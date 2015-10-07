require "ox"

class Nori
  module Parser

    # = Nori::Parser::Nokogiri
    #
    # Ox SAX parser.
    module Ox
			class Document < ::Ox::Sax
			  attr_accessor :options

        def stack
          @stack ||= []
        end

			  def initialize()
			    @results = []
			    @tag = nil
			    @item = nil
			    @tags = []
			  end

			  def start_element(name)
			    stack.push Nori::XMLUtilityNode.new(options, name.to_s, {}) # TODO attributes
			  end

			  def end_element(name)
			    if stack.size > 1
            last = stack.pop
            maybe_string = last.children.last
            if maybe_string.is_a?(String) and maybe_string.strip.empty?
              last.children.pop
            end
            stack.last.add_node last
          end
			  end

			  def text(string)
			    last = stack.last
          if last and last.children.last.is_a?(String) or string.strip.size > 0
            last.add_node(string)
          end
			  end

			end

			def self.parse(xml, options)
        document = Document.new
        document.options = options
        ::Ox.sax_parse(document, StringIO.new(xml))
        document.stack.length > 0 ? document.stack.pop.to_hash : {}
      end

    end
  end
end    