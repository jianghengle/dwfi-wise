require "./controller_base"

module MyServer
  module HttpAPI
    module VisitingScholarController
      include MyServer::HttpAPI::ControllerBase
      extend self

      def get_visiting_scholars(ctx)
        begin
          user = verify_token(ctx)
          items = VisitingScholar.get_visiting_scholars
          "[" + (items.join(", ") { |i| i.to_json }) + "]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def get_visiting_scholar(ctx)
        begin
          user = verify_token(ctx)
          id = get_param!(ctx, "id").to_i
          visiting_scholar = VisitingScholar.get_visiting_scholar(id)
          people_relations = PeopleRelation.get_relations("visiting_scholars", id)
          people_relations_json = "[" + people_relations.join(", ") { |r| r.to_json } + "]"
          publication_relations = PublicationRelation.get_relations("visiting_scholars", id)
          publication_relations_json = "[" + publication_relations.join(", ") { |r| r.to_json } + "]"
          file_relations = FileRelation.get_relations("visiting_scholars", id)
          file_relations_json = "[" + file_relations.join(", ") { |r| r.to_json } + "]"
          grant_relations = GrantRelation.get_relations("visiting_scholars", id)
          grant_relations_json = "[" + grant_relations.join(", ") { |r| r.to_json } + "]"
          "[ #{visiting_scholar.to_json}, #{people_relations_json}, #{publication_relations_json}, #{file_relations_json}, #{grant_relations_json}]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def create_visiting_scholar(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          visiting_scholar = VisitingScholar.new
          visiting_scholar.first_name = get_param!(ctx, "firstName")
          visiting_scholar.last_name = get_param!(ctx, "lastName")
          visiting_scholar.description = get_param!(ctx, "description")
          visiting_scholar.status = get_param!(ctx, "status")
          visiting_scholar.country = get_param!(ctx, "country")
          visiting_scholar.state = get_param!(ctx, "state")
          visiting_scholar.focus_area = get_param!(ctx, "focusArea")
          visiting_scholar.research_topic = get_param!(ctx, "researchTopic")
          start_date = get_param!(ctx, "startDate")
          visiting_scholar.start_date = Time.epoch(start_date.to_i) unless start_date == ""
          end_date = get_param!(ctx, "endDate")
          visiting_scholar.end_date = Time.epoch(end_date.to_i) unless end_date == ""
          visiting_scholar.funding = get_param!(ctx, "funding")
          visiting_scholar.collaborators = get_param!(ctx, "collaborators")
          visiting_scholar.more_information = get_param!(ctx, "moreInformation")
          point_of_contact = get_param!(ctx, "pointOfContact")
          visiting_scholar.point_of_contact = point_of_contact.to_i unless point_of_contact == ""
          visiting_scholar.is_published = get_param!(ctx, "isPublished") == "true"

          people = Array(PeopleRelation).from_json(get_param!(ctx, "people"))
          publications = Array(PublicationRelation).from_json(get_param!(ctx, "publications"))
          files = Array(FileRelation).from_json(get_param!(ctx, "files"))
          grants = Array(GrantRelation).from_json(get_param!(ctx, "grants"))

          VisitingScholar.create_visiting_scholar(visiting_scholar, people, publications, files, grants)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def update_visiting_scholar(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          visiting_scholar = VisitingScholar.new
          visiting_scholar.id = get_param!(ctx, "id").to_i
          visiting_scholar.first_name = get_param!(ctx, "firstName")
          visiting_scholar.last_name = get_param!(ctx, "lastName")
          visiting_scholar.description = get_param!(ctx, "description")
          visiting_scholar.status = get_param!(ctx, "status")
          visiting_scholar.country = get_param!(ctx, "country")
          visiting_scholar.state = get_param!(ctx, "state")
          visiting_scholar.focus_area = get_param!(ctx, "focusArea")
          visiting_scholar.research_topic = get_param!(ctx, "researchTopic")
          start_date = get_param!(ctx, "startDate")
          visiting_scholar.start_date = Time.epoch(start_date.to_i) unless start_date == ""
          end_date = get_param!(ctx, "endDate")
          visiting_scholar.end_date = Time.epoch(end_date.to_i) unless end_date == ""
          visiting_scholar.funding = get_param!(ctx, "funding")
          visiting_scholar.collaborators = get_param!(ctx, "collaborators")
          visiting_scholar.more_information = get_param!(ctx, "moreInformation")
          point_of_contact = get_param!(ctx, "pointOfContact")
          visiting_scholar.point_of_contact = point_of_contact.to_i unless point_of_contact == ""
          visiting_scholar.is_published = get_param!(ctx, "isPublished") == "true"

          people = Array(PeopleRelation).from_json(get_param!(ctx, "people"))
          publications = Array(PublicationRelation).from_json(get_param!(ctx, "publications"))
          files = Array(FileRelation).from_json(get_param!(ctx, "files"))
          grants = Array(GrantRelation).from_json(get_param!(ctx, "grants"))

          VisitingScholar.update_visiting_scholar(visiting_scholar, people, publications, files, grants)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def delete_visiting_scholar(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          visiting_scholar_id = get_param!(ctx, "visitingScholarId").to_i
          VisitingScholar.delete_visiting_scholar(visiting_scholar_id)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def count_visiting_scholars_for_map(ctx)
        begin
          items = VisitingScholar.get_published_visiting_scholars
          ids = items.map { |i| i.id }
          relation_map = GrantRelation.get_relation_map("visiting_scholars", ids)
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

      def get_visiting_scholars_for_map(ctx)
        begin
          country = URI.unescape(get_param!(ctx, "country"))
          items = VisitingScholar.get_published_visiting_scholars(country)
          ids = items.map { |i| i.id }
          people_relation_map = PeopleRelation.get_relation_map("visiting_scholars", ids)
          grant_relation_map = GrantRelation.get_relation_map("visiting_scholars", ids)
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
