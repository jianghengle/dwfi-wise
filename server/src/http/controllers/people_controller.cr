require "./controller_base"

module MyServer
  module HttpAPI
    module PeopleController
      include MyServer::HttpAPI::ControllerBase
      extend self

      def get_people(ctx)
        begin
          user = verify_token(ctx)
          items = People.get_all_people
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
