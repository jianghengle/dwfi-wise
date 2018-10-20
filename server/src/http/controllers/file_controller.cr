require "./controller_base"

module MyServer
  module HttpAPI
    module FileController
      include MyServer::HttpAPI::ControllerBase
      extend self

      def get_files(ctx)
        begin
          user = verify_token(ctx)
          items = MyFile.get_files
          arr = [] of String
          "[" + (items.join(", ") { |i| i.to_json }) + "]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def get_file(ctx)
        begin
          user = verify_token(ctx)
          id = get_param!(ctx, "id").to_i
          file = MyFile.get_file(id)
          file.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def create_file(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          uploadFile = get_body!(ctx, "uploadFile")
          if uploadFile == "Yes"
            file = ctx.params.files["file"]
            file_type = get_body!(ctx, "fileType")
            MyFile.create_file_by_upload(file, file_type)
          else
            file = MyFile.new
            file.name = get_body!(ctx, "name")
            file.file_type = get_body!(ctx, "fileType")
            file.url = get_body!(ctx, "url")
            MyFile.create_file(file)
          end

          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def update_file(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          file = MyFile.new
          file.id = get_param!(ctx, "id").to_i
          file.name = get_param!(ctx, "name")
          file.file_type = get_param!(ctx, "fileType")
          file.url = get_param!(ctx, "url")

          MyFile.update_file(file)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def delete_file(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          file_id = get_param!(ctx, "fileId").to_i
          MyFile.delete_file(file_id)
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
