require "./controller_base"

module MyServer
  module HttpAPI
    module PeopleController
      include MyServer::HttpAPI::ControllerBase
      extend self

      def get_people(ctx)
        begin
          items = People.get_all_people
          "[" + (items.join(", ") { |i| i.to_json }) + "]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def get_one_people(ctx)
        begin
          user = verify_token(ctx)
          id = get_param!(ctx, "id").to_i
          people = People.get_one_people(id)
          file_relations = FileRelation.get_relations("people", id)
          file_relations_json = "[" + file_relations.join(", ") { |r| r.to_json } + "]"
          "[ #{people.to_json}, #{file_relations_json}]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def create_people(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          people = People.new
          people.first_name = get_param!(ctx, "firstName")
          people.last_name = get_param!(ctx, "lastName")
          people.credentials = get_param!(ctx, "credentials")
          people.title = get_param!(ctx, "title")
          people.employer = get_param!(ctx, "employer")
          people.dwfi_affiliation = get_param!(ctx, "dwfiAffiliation")
          people.email = get_param!(ctx, "email")
          people.phone = get_param!(ctx, "phone")
          people.website = get_param!(ctx, "website")

          files = Array(FileRelation).from_json(get_param!(ctx, "files"))

          People.create_people(people, files)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def update_people(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          people = People.new
          people.id = get_param!(ctx, "id").to_i
          people.first_name = get_param!(ctx, "firstName")
          people.last_name = get_param!(ctx, "lastName")
          people.credentials = get_param!(ctx, "credentials")
          people.title = get_param!(ctx, "title")
          people.employer = get_param!(ctx, "employer")
          people.dwfi_affiliation = get_param!(ctx, "dwfiAffiliation")
          people.email = get_param!(ctx, "email")
          people.phone = get_param!(ctx, "phone")
          people.website = get_param!(ctx, "website")

          files = Array(FileRelation).from_json(get_param!(ctx, "files"))

          People.update_people(people, files)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def delete_people(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          people_id = get_param!(ctx, "peopleId").to_i
          People.delete_people(people_id)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def export_people_only(ctx)
        begin
          user = verify_token(ctx)
          ids = Array(Int64).from_json(get_param!(ctx, "ids"))
          People.export_people_only(ids)
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def export_people(ctx)
        begin
          user = verify_token(ctx)
          table_name = get_param!(ctx, "table")
          ids = Array(Int64).from_json(get_param!(ctx, "ids"))
          People.export_people(table_name, ids)
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end
    end
  end
end
