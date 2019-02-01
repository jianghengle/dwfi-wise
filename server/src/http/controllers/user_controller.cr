require "./controller_base"

module MyServer
  module HttpAPI
    module UserController
      include MyServer::HttpAPI::ControllerBase
      extend self

      def get_auth_token(ctx)
        begin
          email = get_param!(ctx, "email")
          password = get_param!(ctx, "password")

          user = User.get_user(email, password)
          raise "Inactive user" if user.privileges.to_s == "None"

          token = user.auth_token.to_s
          email = user.email.to_s
          privileges = user.privileges.to_s
          {token: token, email: email, privileges: privileges}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def register(ctx)
        begin
          email = get_param!(ctx, "email")
          password = get_param!(ctx, "password")
          User.create_user(email, password)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def change_password(ctx)
        begin
          user = verify_token(ctx)
          password = get_param!(ctx, "password")
          User.change_password(user, password)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def get_users(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless user.privileges.to_s == "Approve"
          users = User.get_users
          "[" + (users.join(", ") { |i| i.to_json }) + "]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def update_user(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless user.privileges.to_s == "Approve"

          id = get_param!(ctx, "id").to_i
          privileges = get_param!(ctx, "privileges")
          User.update_user(id, privileges)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def delete_user(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless user.privileges.to_s == "Approve"

          id = get_param!(ctx, "id").to_i
          User.delete_user(id)
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
