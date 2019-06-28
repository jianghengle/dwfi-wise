require "./controller_base"

module MyServer
  module HttpAPI
    module ImpactController
      include MyServer::HttpAPI::ControllerBase
      extend self

      def get_impacts(ctx)
        begin
          items = Impact.get_impacts
          arr = [] of String
          "[" + (items.join(", ") { |i| i.to_json }) + "]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def get_impact(ctx)
        begin
          user = verify_token(ctx)
          id = get_param!(ctx, "id").to_i
          impact = Impact.get_impact(id)
          impact.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def create_impact(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          impact = Impact.new
          impact.impact_indicator = get_param!(ctx, "impactIndicator")
          impact.number_field = get_param!(ctx, "numberField").to_i64
          Impact.create_impact(impact)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def update_impact(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          impact = Impact.new
          impact.id = get_param!(ctx, "id").to_i
          impact.impact_indicator = get_param!(ctx, "impactIndicator")
          impact.number_field = get_param!(ctx, "numberField").to_i64

          Impact.update_impact(impact)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def delete_impact(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          impact_id = get_param!(ctx, "impactId").to_i
          Impact.delete_impact(impact_id)
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
