require_relative "error"
require "parser/current"

module Jekyll
  module KrokiTag
    class SyntaxError < Error; end

    class ArgumentError < Error; end

    class MissingRequiredArgument < Error; end

    class OptionParser
      DEFINED_KWORDS = %w[type format alt caption].map(&:to_sym).freeze

      #
      # @param [string] args
      #
      class << self
        #
        # @param [string] args
        # @return [Hash]
        #
        def parse(args)
          parser = new(args)
          parser.opts
        end
      end

      #
      # @param [string] args
      #
      def initialize(args)
        @opts = parse!(args)
      end
      attr_reader :tree, :opts

      #
      # @param [string] args
      # @return [Hash]
      #
      def parse!(args)
        @tree = Parser::CurrentRuby.parse("{ #{args} }")

        opts = Hash[*node_value(@tree.to_sexp_array).flatten]

        if valid_options?(opts)
          raise MissingRequiredArgument.new("required arg `type` is missing") unless opts[:type]
          normalize(opts)
        end
      rescue Parser::SyntaxError => e
        raise SyntaxError.new(e)
      end

      #
      # @param [Hash] opts
      # @return [Hash]
      #
      def normalize(opts)
        opts[:format] ||= "svg"
        [:type, :format].each { |k|
          opts[k].downcase!
        }

        opts
      end

      #
      # @param [array] opts
      # @return [true]
      #
      def valid_options?(opts)
        opts.all? { |key, val|
          config = key.to_s.downcase.sub(/:$/, "").to_sym # standard:disable Lint/RedundantStringCoercion

          DEFINED_KWORDS.include?(config) || raise(ArgumentError.new("`#{config}` is not allowed keyword"))
        }
      end

      #
      # make sexp into type-type array of array
      #
      # [[:sym, :str], [:sym, :sym], ...]
      #
      def node_type(ast_array)
        node_attribute(ast_array, key: :type)
      end

      #
      # make sexp into value-value array of array
      #
      # [[:type, "plantuml"], [:format, "png"], ...]
      #
      def node_value(ast_array)
        node_attribute(ast_array, key: :value)
      end

      #
      # @param [array] ast_array
      # @param [Symnol] key
      # @return [array]
      #
      def node_attribute(ast_array, key: :type)
        type, *vals = ast_array

        case type
        when :hash
          vals.map { |e| node_attribute(e, key: key) }
        when :pair
          vals.map { |e| node_attribute(e, key: key) }
        when :sym, :str, :int, :float
          if key == :type
            type
          else
            vals.first
          end
        else
          raise ArgumentError.new("#{vals} is not in type Symbol, String, Integer and Float. Did you write invalid syntax ?")
        end
      end
    end
  end
end
