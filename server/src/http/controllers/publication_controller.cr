require "./controller_base"

module MyServer
  module HttpAPI
    module PublicationController
      include MyServer::HttpAPI::ControllerBase
      extend self

      def get_publications(ctx)
        begin
          user = verify_token(ctx)
          items = Publication.get_publications
          "[" + (items.join(", ") { |i| i.to_json }) + "]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end
    end
  end
end
