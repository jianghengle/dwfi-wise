require "./controller_base"

module MyServer
  module HttpAPI
    module GrantController
      include MyServer::HttpAPI::ControllerBase
      extend self

      def get_grants(ctx)
        begin
          user = verify_token(ctx)
          items = Grant.get_grants
          arr = [] of String
          "[" + (items.join(", ") { |i| i.to_json }) + "]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def get_grant(ctx)
        begin
          user = verify_token(ctx)
          id = get_param!(ctx, "id").to_i
          grant = Grant.get_grant(id)
          grant.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def create_grant(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          grant = Grant.new
          grant.organization = get_param!(ctx, "organization")
          Grant.create_grant(grant)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def update_grant(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          grant = Grant.new
          grant.id = get_param!(ctx, "id").to_i
          grant.organization = get_param!(ctx, "organization")

          Grant.update_grant(grant)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def delete_grant(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          grant_id = get_param!(ctx, "grantId").to_i
          Grant.delete_grant(grant_id)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end
    end
  end
end
