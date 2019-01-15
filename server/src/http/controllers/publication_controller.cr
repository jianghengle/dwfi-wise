require "./controller_base"

module MyServer
  module HttpAPI
    module PublicationController
      include MyServer::HttpAPI::ControllerBase
      extend self

      def get_publications(ctx)
        begin
          user = verify_token(ctx)
          items = Publication.get_publications
          "[" + (items.join(", ") { |i| i.to_json }) + "]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def get_publication(ctx)
        begin
          user = verify_token(ctx)
          id = get_param!(ctx, "id").to_i
          publication = Publication.get_publication(id)
          file_relations = FileRelation.get_relations("publications", id)
          file_relations_json = "[" + file_relations.join(", ") { |r| r.to_json } + "]"
          people_relations = PeopleRelation.get_relations("publications", id)
          people_relations_json = "[" + people_relations.join(", ") { |r| r.to_json } + "]"
          grant_relations = GrantRelation.get_relations("publications", id)
          grant_relations_json = "[" + grant_relations.join(", ") { |r| r.to_json } + "]"
          "[ #{publication.to_json}, #{file_relations_json}, #{people_relations_json}, #{grant_relations_json}]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def create_publication(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          publication = Publication.new
          publication.title = get_param!(ctx, "title")
          publication.authors = get_param!(ctx, "authors")
          publication.abstract = get_param!(ctx, "abstract")
          publication.focus_area = get_param!(ctx, "focusArea")
          publication.status = get_param!(ctx, "status")
          publication.url = get_param!(ctx, "url")
          point_of_contact = get_param!(ctx, "pointOfContact")
          publication.point_of_contact = point_of_contact.to_i unless point_of_contact == ""
          publication.country = get_param!(ctx, "country")

          files = Array(FileRelation).from_json(get_param!(ctx, "files"))
          people = Array(PeopleRelation).from_json(get_param!(ctx, "people"))
          grants = Array(GrantRelation).from_json(get_param!(ctx, "grants"))

          Publication.create_publication(publication, files, people, grants)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def update_publication(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          publication = Publication.new
          publication.id = get_param!(ctx, "id").to_i
          publication.title = get_param!(ctx, "title")
          publication.authors = get_param!(ctx, "authors")
          publication.abstract = get_param!(ctx, "abstract")
          publication.focus_area = get_param!(ctx, "focusArea")
          publication.status = get_param!(ctx, "status")
          publication.url = get_param!(ctx, "url")
          point_of_contact = get_param!(ctx, "pointOfContact")
          publication.point_of_contact = point_of_contact.to_i unless point_of_contact == ""
          publication.country = get_param!(ctx, "country")

          files = Array(FileRelation).from_json(get_param!(ctx, "files"))
          people = Array(PeopleRelation).from_json(get_param!(ctx, "people"))
          grants = Array(GrantRelation).from_json(get_param!(ctx, "grants"))

          Publication.update_publication(publication, files, people, grants)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def delete_publication(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          publication_id = get_param!(ctx, "publicationId").to_i
          Publication.delete_publication(publication_id)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def count_publications_for_map(ctx)
        begin
          items = Publication.get_published_publications
          ids = items.map { |i| i.id }
          relation_map = GrantRelation.get_relation_map("publications", ids)
          people_map = PeopleRelation.get_relation_map("publications", ids)
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

      def export_publications(ctx)
        begin
          user = verify_token(ctx)
          table_name = get_param!(ctx, "table")
          ids = Array(Int64).from_json(get_param!(ctx, "ids"))
          Publication.export_publications(table_name, ids)
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end
    end
  end
end
