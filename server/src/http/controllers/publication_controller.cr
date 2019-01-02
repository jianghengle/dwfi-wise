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
          "[ #{publication.to_json}, #{file_relations_json}]"
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

          files = Array(FileRelation).from_json(get_param!(ctx, "files"))

          Publication.create_publication(publication, files)
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

          files = Array(FileRelation).from_json(get_param!(ctx, "files"))

          Publication.update_publication(publication, files)
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
