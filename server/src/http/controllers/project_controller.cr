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
          project.start_date = Time.unix(start_date.to_i) unless start_date == ""
          end_date = get_param!(ctx, "endDate")
          project.end_date = Time.unix(end_date.to_i) unless end_date == ""
          project.funding = get_param!(ctx, "funding")
          project.collaborators = get_param!(ctx, "collaborators")
          project.more_information = get_param!(ctx, "moreInformation")
          point_of_contact = get_param!(ctx, "pointOfContact")
          project.point_of_contact = point_of_contact.to_i unless point_of_contact == ""
          project.website = get_param!(ctx, "website")
          project.is_published = get_param!(ctx, "isPublished") == "true"
          progress = get_param!(ctx, "progress")
          project.progress = progress unless progress == ""
          progress_time = get_param!(ctx, "progressTime")
          project.progress_time = Time.unix(progress_time.to_i) unless progress_time == ""

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

          id = get_param!(ctx, "id").to_i
          project = Project.get_project(id).as(Project)

          project.title = get_param!(ctx, "title")
          project.description = get_param!(ctx, "description")
          project.status = get_param!(ctx, "status")
          project.country = get_param!(ctx, "country")
          project.state = get_param!(ctx, "state")
          project.focus_area = get_param!(ctx, "focusArea")
          program_id = get_param!(ctx, "programId")
          project.program_id = program_id.to_i unless program_id == ""
          start_date = get_param!(ctx, "startDate")
          project.start_date = Time.unix(start_date.to_i) unless start_date == ""
          end_date = get_param!(ctx, "endDate")
          project.end_date = Time.unix(end_date.to_i) unless end_date == ""
          project.funding = get_param!(ctx, "funding")
          project.collaborators = get_param!(ctx, "collaborators")
          project.more_information = get_param!(ctx, "moreInformation")
          point_of_contact = get_param!(ctx, "pointOfContact")
          project.point_of_contact = point_of_contact.to_i unless point_of_contact == ""
          project.website = get_param!(ctx, "website")
          project.is_published = get_param!(ctx, "isPublished") == "true"
          progress = get_param!(ctx, "progress")
          progress = nil if progress == ""
          project.progress_time = Time.now if project.progress != progress
          project.progress = progress

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
          relation_map = GrantRelation.get_relation_map("projects", ids)
          people_map = PeopleRelation.get_relation_map("projects", ids)
          str = items.join(", ") do |i|
            people = [] of PeopleRelation
            people = people_map[i.id.to_s] if people_map.has_key?(i.id.to_s)
            grants = [] of GrantRelation
            grants = relation_map[i.id.to_s] if relation_map.has_key?(i.id.to_s)
            i.to_json_for_count(grants, people)
          end
          "[#{str}]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def get_projects_for_map(ctx)
        begin
          country = URI.unescape(get_param!(ctx, "country"))
          items = Project.get_published_projects(country)
          ids = items.map { |i| i.id }
          people_relation_map = PeopleRelation.get_relation_map("projects", ids)
          grant_relation_map = GrantRelation.get_relation_map("projects", ids)
          project_program_map = Program.get_project_program_map(items)
          str = items.join(", ") do |i|
            id = i.id.to_s
            people = [] of PeopleRelation
            people = people_relation_map[id] if people_relation_map.has_key?(id)
            grants = [] of GrantRelation
            grants = grant_relation_map[id] if grant_relation_map.has_key?(id)
            program_title = ""
            program_title = project_program_map[id] if project_program_map.has_key?(id)
            i.to_json_for_map(people, grants, program_title)
          end
          "[#{str}]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def request_project_update(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless user.privileges.to_s == "Approve"
          id = get_param!(ctx, "id").to_i
          request = get_param!(ctx, "request") == "true"
          Project.request_project_update(id, request, user)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def get_requested_project(ctx)
        begin
          key = get_param!(ctx, "key")
          project = Project.get_project_by_key(key)
          id = project.id
          publication_relations = PublicationRelation.get_relations("projects", id)
          publication_relations_json = "[" + publication_relations.join(", ") { |r| r.to_json } + "]"
          file_relations = FileRelation.get_relations("projects", id)
          file_relations_json = "[" + file_relations.join(", ") { |r| r.to_json } + "]"
          grant_relations = GrantRelation.get_relations("projects", id)
          grant_relations_json = "[" + grant_relations.join(", ") { |r| r.to_json } + "]"
          "[ #{project.to_json}, #{publication_relations_json}, #{file_relations_json}, #{grant_relations_json}]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def update_requested_project(ctx)
        begin
          key = get_param!(ctx, "key")
          project = Project.get_project_by_key(key)

          project.description = get_param!(ctx, "description")
          project.status = get_param!(ctx, "status")
          project.country = get_param!(ctx, "country")
          project.state = get_param!(ctx, "state")
          start_date = get_param!(ctx, "startDate")
          project.start_date = Time.unix(start_date.to_i) unless start_date == ""
          end_date = get_param!(ctx, "endDate")
          project.end_date = Time.unix(end_date.to_i) unless end_date == ""
          project.funding = get_param!(ctx, "funding")
          project.collaborators = get_param!(ctx, "collaborators")

          progress = get_param!(ctx, "progress")
          progress = nil if progress == ""
          project.progress_time = Time.now if project.progress != progress
          project.progress = progress

          publications = Array(PublicationRelation).from_json(get_param!(ctx, "publications"))
          files = Array(FileRelation).from_json(get_param!(ctx, "files"))
          grants = Array(GrantRelation).from_json(get_param!(ctx, "grants"))

          Project.update_requested_project(project, publications, files, grants)
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
