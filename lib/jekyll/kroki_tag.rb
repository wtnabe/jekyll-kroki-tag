# frozen_string_literal: true

require "base64"
require "zlib"
require "parser/current"
require_relative "kroki_tag/version"

module Jekyll
  module KrokiTag
    class Error < StandardError; end

    DEFINED_KWORDS = %w[type format alt caption].map(&:to_sym).freeze

    module Util
      class KrokiTagArgumentError < Error; end

      #
      # @param [string] args
      # @return [Hash]
      #
      def parse_args(args)
        opts = Hash[*args.strip.split(/\s+/).each_slice(2).map { |key, val|
          config = key.downcase.sub(/:$/, "").to_sym

          raise KrokiTagArgumentError.new(config) unless DEFINED_KWORDS.include?(config)
          [config, val]
        }.flatten]

        raise KrokiTagArgumentError.new("required arg `type` is missing") unless opts[:type]

        opts
      end

      #
      # @param [string] diagram
      # @return [string]
      #
      def encode_diagram(diagram)
        Base64.urlsafe_encode64(Zlib.deflate(diagram))
      end

      #
      # @param [string] str
      # @return [string]
      #
      def attribute(str)
        CGI.escapeHTML(str.sub(/^['"]/, "").sub(/['"]$/, ""))
      end

      #
      # @param [Symbol|String] type - diagram type
      # @param [Symbol|String] format - imgage ( or document ) format
      # @param [String] content - diagram content
      # @return [URI]
      #
      def uri(type:, format:, content:)
        URI.join("https://kroki.io/", [type, format, encode_diagram(content)].map { |e| URI.encode_www_form_component(e) }.join("/"))
      end
    end

    class Block < ::Liquid::Block
      include Liquid::StandardFilters
      include Util

      class << self
        #
        # if you want to customize, read from `site.config`
        #
        # @param [Jekyll:Site] site
        #
        def register(site)
          Liquid::Template.register_tag("kroki", self)
        end
      end

      #
      # @param [string] tag_name
      # @param [string] text
      # @param [Object] tokens
      #
      def initialize(tag_name, text, tokens)
        super

        @opts = parse_args(text)
        @opts[:format] ||= "svg"
      end

      #
      # @param [Liquid::Context] context
      # @return [string]
      #
      def render(context)
        inner_text = super

        u = uri(type: @opts[:type], format: @opts[:format], content: inner_text).to_s
        img =
          if @opts[:alt]
            "<img src=\"#{u}\" alt=\"#{attribute(@opts[:alt])}\">"
          else
            "<img src=\"#{u}\">"
          end

        caption = "<figcaption>#{attribute(@opts[:caption])}</figcaption>" if @opts[:caption]

        <<-EOD.chomp
  <figure class="jekyll-kroki" data-kroki-type="#{@opts[:type]}" data-kroki-format="#{@opts[:format]}">
    #{img}
    #{caption}
  </figure>
        EOD
      end
    end
  end
end

Jekyll::Hooks.register(:site, :post_read) do |site|
  Jekyll::KrokiTag::Block.register(site)
end
