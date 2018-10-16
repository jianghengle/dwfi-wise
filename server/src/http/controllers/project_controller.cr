require "./controller_base"

module MyServer
  module HttpAPI
    module ProjectController
      include MyServer::HttpAPI::ControllerBase
      extend self

      def get_projects(ctx)
        begin
          user = verify_token(ctx)
          items = Project.get_projects
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
