require "./controller_base"

module MyServer
  module HttpAPI
    module ProgramController
      include MyServer::HttpAPI::ControllerBase
      extend self

      def get_programs(ctx)
        begin
          user = verify_token(ctx)
          items = Program.get_programs
          "[" + (items.join(", ") { |i| i.to_json }) + "]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def get_program(ctx)
        begin
          user = verify_token(ctx)
          id = get_param!(ctx, "id").to_i
          program = Program.get_program(id)
          people_relations = PeopleRelation.get_relations("programs", id)
          people_relations_json = "[" + people_relations.join(", ") { |r| r.to_json } + "]"
          publication_relations = PublicationRelation.get_relations("programs", id)
          publication_relations_json = "[" + publication_relations.join(", ") { |r| r.to_json } + "]"
          file_relations = FileRelation.get_relations("programs", id)
          file_relations_json = "[" + file_relations.join(", ") { |r| r.to_json } + "]"
          grant_relations = GrantRelation.get_relations("programs", id)
          grant_relations_json = "[" + grant_relations.join(", ") { |r| r.to_json } + "]"
          "[ #{program.to_json}, #{people_relations_json}, #{publication_relations_json}, #{file_relations_json}, #{grant_relations_json}]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def create_program(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          program = Program.new
          program.title = get_param!(ctx, "title")
          program.description = get_param!(ctx, "description")
          program.status = get_param!(ctx, "status")
          program.country = get_param!(ctx, "country")
          program.state = get_param!(ctx, "state")
          program.focus_area = get_param!(ctx, "focusArea")
          start_date = get_param!(ctx, "startDate")
          program.start_date = Time.epoch(start_date.to_i) unless start_date == ""
          end_date = get_param!(ctx, "endDate")
          program.end_date = Time.epoch(end_date.to_i) unless end_date == ""
          program.funding = get_param!(ctx, "funding")
          program.collaborators = get_param!(ctx, "collaborators")
          program.more_information = get_param!(ctx, "moreInformation")
          program.point_of_contact = get_param!(ctx, "pointOfContact")
          program.website = get_param!(ctx, "website")
          program.is_published = get_param!(ctx, "isPublished") == "true"

          people = Array(PeopleRelation).from_json(get_param!(ctx, "people"))
          publications = Array(PublicationRelation).from_json(get_param!(ctx, "publications"))
          files = Array(FileRelation).from_json(get_param!(ctx, "files"))
          grants = Array(GrantRelation).from_json(get_param!(ctx, "grants"))

          Program.create_program(program, people, publications, files, grants)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def update_program(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          program = Program.new
          program.id = get_param!(ctx, "id").to_i
          program.title = get_param!(ctx, "title")
          program.description = get_param!(ctx, "description")
          program.status = get_param!(ctx, "status")
          program.country = get_param!(ctx, "country")
          program.state = get_param!(ctx, "state")
          program.focus_area = get_param!(ctx, "focusArea")
          start_date = get_param!(ctx, "startDate")
          program.start_date = Time.epoch(start_date.to_i) unless start_date == ""
          end_date = get_param!(ctx, "endDate")
          program.end_date = Time.epoch(end_date.to_i) unless end_date == ""
          program.funding = get_param!(ctx, "funding")
          program.collaborators = get_param!(ctx, "collaborators")
          program.more_information = get_param!(ctx, "moreInformation")
          program.point_of_contact = get_param!(ctx, "pointOfContact")
          program.website = get_param!(ctx, "website")
          program.is_published = get_param!(ctx, "isPublished") == "true"

          people = Array(PeopleRelation).from_json(get_param!(ctx, "people"))
          publications = Array(PublicationRelation).from_json(get_param!(ctx, "publications"))
          files = Array(FileRelation).from_json(get_param!(ctx, "files"))
          grants = Array(GrantRelation).from_json(get_param!(ctx, "grants"))

          Program.update_program(program, people, publications, files, grants)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def delete_program(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          program_id = get_param!(ctx, "programId").to_i
          Program.delete_program(program_id)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def count_programs_for_map(ctx)
        begin
          items = Program.get_published_programs
          ids = items.map { |i| i.id }
          relation_map = GrantRelation.get_relation_map("programs", ids)
          str = items.join(", ") do |i|
            grants = [] of GrantRelation
            grants = relation_map[i.id.to_s] if relation_map.has_key?(i.id.to_s)
            i.to_json_for_count(grants)
          end
          "[#{str}]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def get_programs_for_map(ctx)
        begin
          country = URI.unescape(get_param!(ctx, "country"))
          items = Program.get_published_programs(country)
          ids = items.map { |i| i.id }
          people_relation_map = PeopleRelation.get_relation_map("programs", ids)
          grant_relation_map = GrantRelation.get_relation_map("programs", ids)
          str = items.join(", ") do |i|
            id = i.id.to_s
            people = [] of PeopleRelation
            people = people_relation_map[id] if people_relation_map.has_key?(id)
            grants = [] of GrantRelation
            grants = grant_relation_map[id] if grant_relation_map.has_key?(id)
            i.to_json_for_map(people, grants)
          end
          "[#{str}]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end
    end
  end
end
