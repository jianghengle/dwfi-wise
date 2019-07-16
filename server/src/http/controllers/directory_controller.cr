require "./controller_base"

module MyServer
  module HttpAPI
    module DirectoryController
      include MyServer::HttpAPI::ControllerBase
      extend self

      def get_directories(ctx)
        begin
          items = Directory.get_directories
          return "[]" if items.empty?

          people_ids = items.map { |f| f.people_id }
          people_map = People.get_people_map(people_ids)
          "[" + (items.join(", ") { |i| i.to_json(people_map[i.people_id.to_s]) }) + "]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def kumu_directory(ctx)
        begin
          items = Directory.get_directories
          return "[]" if items.empty?

          people_ids = items.map { |f| f.people_id }
          people_map = People.get_people_map(people_ids)
          "[" + (items.join(", ") { |i| i.to_kumu_json(people_map[i.people_id.to_s]) }) + "]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def get_directory(ctx)
        begin
          user = verify_token(ctx)
          id = get_param!(ctx, "id").to_i
          directory = Directory.get_directory(id)
          raise "cannot find directory" if directory.nil?
          people_map = People.get_people_map([directory.people_id])
          people = people_map[directory.people_id.to_s]
          directory.to_json(people)
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def create_directory(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          directory = Directory.new
          directory.people_id = get_param!(ctx, "peopleId")
          directory.typ = get_param!(ctx, "typ")
          directory.role = get_param!(ctx, "role")
          directory.tags = get_param!(ctx, "tags")
          directory.institution = get_param!(ctx, "institution")
          directory.department = get_param!(ctx, "department")
          directory.area = get_param!(ctx, "area")
          directory.specialty = get_param!(ctx, "specialty")
          Directory.create_directory(directory)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def update_directory(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          directory = Directory.new
          directory.id = get_param!(ctx, "id").to_i
          directory.people_id = get_param!(ctx, "peopleId")
          directory.typ = get_param!(ctx, "typ")
          directory.role = get_param!(ctx, "role")
          directory.tags = get_param!(ctx, "tags")
          directory.institution = get_param!(ctx, "institution")
          directory.department = get_param!(ctx, "department")
          directory.area = get_param!(ctx, "area")
          directory.specialty = get_param!(ctx, "specialty")
          Directory.update_directory(directory)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def delete_directory(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          directory_id = get_param!(ctx, "directoryId").to_i
          Directory.delete_directory(directory_id)
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
