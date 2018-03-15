module Esplanade
  class Request
    class Error < Esplanade::Error; end

    class PrefixNotMatch        < Error; end
    class NotDocumented         < Error
      attr_reader :method, :path, :content_type

      def initialize(method:, path:, content_type:)
        @method = method
        @path   = path
        @content_type = content_type

        super(to_hash)
      end

      def to_hash
        {
          method: @method,
          path: @path,
          content_type: @content_type
        }
      end
    end
    class ContentTypeIsNotJson  < Error; end
    class BodyIsNotJson         < Error
      def to_hash
        {}
      end
    end

    class Invalid < Error
      attr_reader :method, :path, :content_type, :body, :error

      def initialize(method:, path:, content_type:, body:, error:)
        @method = method
        @path   = path
        @content_type = content_type
        @body   = body
        @error  = error

        super(to_hash)
      end

      def to_hash
        {
          method: @method,
          path:   @path,
          content_type: @content_type,
          body:   @body,
          error:  @error
        }
      end
    end
  end
end
