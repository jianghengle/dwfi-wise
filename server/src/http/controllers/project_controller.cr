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

      def get_project(ctx)
        begin
          user = verify_token(ctx)
          id = get_param!(ctx, "id").to_i
          project = Project.get_project(id)
          people_relations = PeopleRelation.get_relations("projects", id)
          people_relations_json = "[" + people_relations.join(", ") { |r| r.to_json } + "]"
          publication_relations = PublicationRelation.get_relations("projects", id)
          publication_relations_json = "[" + publication_relations.join(", ") { |r| r.to_json } + "]"
          file_relations = FileRelation.get_relations("projects", id)
          file_relations_json = "[" + file_relations.join(", ") { |r| r.to_json } + "]"
          grant_relations = GrantRelation.get_relations("projects", id)
          grant_relations_json = "[" + grant_relations.join(", ") { |r| r.to_json } + "]"
          "[ #{project.to_json}, #{people_relations_json}, #{publication_relations_json}, #{file_relations_json}, #{grant_relations_json}]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def create_project(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          project = Project.new
          project.title = get_param!(ctx, "title")
          project.description = get_param!(ctx, "description")
          project.status = get_param!(ctx, "status")
          project.country = get_param!(ctx, "country")
          project.state = get_param!(ctx, "state")
          project.focus_area = get_param!(ctx, "focusArea")
          program_id = get_param!(ctx, "programId")
          project.program_id = program_id.to_i unless program_id == ""
          start_date = get_param!(ctx, "startDate")
          project.start_date = Time.epoch(start_date.to_i) unless start_date == ""
          end_date = get_param!(ctx, "endDate")
          project.end_date = Time.epoch(end_date.to_i) unless end_date == ""
          project.funding = get_param!(ctx, "funding")
          project.collaborators = get_param!(ctx, "collaborators")
          project.more_information = get_param!(ctx, "moreInformation")
          project.point_of_contact = get_param!(ctx, "pointOfContact")
          project.website = get_param!(ctx, "website")
          project.is_published = get_param!(ctx, "isPublished") == "true"

          people = Array(PeopleRelation).from_json(get_param!(ctx, "people"))
          publications = Array(PublicationRelation).from_json(get_param!(ctx, "publications"))
          files = Array(FileRelation).from_json(get_param!(ctx, "files"))
          grants = Array(GrantRelation).from_json(get_param!(ctx, "grants"))

          Project.create_project(project, people, publications, files, grants)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def update_project(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          project = Project.new
          project.id = get_param!(ctx, "id").to_i
          project.title = get_param!(ctx, "title")
          project.description = get_param!(ctx, "description")
          project.status = get_param!(ctx, "status")
          project.country = get_param!(ctx, "country")
          project.state = get_param!(ctx, "state")
          project.focus_area = get_param!(ctx, "focusArea")
          program_id = get_param!(ctx, "programId")
          project.program_id = program_id.to_i unless program_id == ""
          start_date = get_param!(ctx, "startDate")
          project.start_date = Time.epoch(start_date.to_i) unless start_date == ""
          end_date = get_param!(ctx, "endDate")
          project.end_date = Time.epoch(end_date.to_i) unless end_date == ""
          project.funding = get_param!(ctx, "funding")
          project.collaborators = get_param!(ctx, "collaborators")
          project.more_information = get_param!(ctx, "moreInformation")
          project.point_of_contact = get_param!(ctx, "pointOfContact")
          project.website = get_param!(ctx, "website")
          project.is_published = get_param!(ctx, "isPublished") == "true"

          people = Array(PeopleRelation).from_json(get_param!(ctx, "people"))
          publications = Array(PublicationRelation).from_json(get_param!(ctx, "publications"))
          files = Array(FileRelation).from_json(get_param!(ctx, "files"))
          grants = Array(GrantRelation).from_json(get_param!(ctx, "grants"))

          Project.update_project(project, people, publications, files, grants)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def delete_project(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          project_id = get_param!(ctx, "projectId").to_i
          Project.delete_project(project_id)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def count_projects_for_map(ctx)
        begin
          items = Project.get_published_projects
          ids = items.map { |i| i.id }
          relations = GrantRelation.get_relations_for_ids("projects", ids)
          relation_map = Hash(String, Array(String)).new
          relations.each do |r|
            id = r.for_id.to_s
            relation_map[id] = ([] of String) unless relation_map.has_key?(id)
            relation_map[id] << r.grant_id.to_s
          end
          str = items.join(", ") do |i|
            grands = [] of String
            grands = relation_map[i.id.to_s] if relation_map.has_key?(i.id.to_s)
            i.to_json_with_grants(grands)
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
