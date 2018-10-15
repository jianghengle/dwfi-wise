require "./controller_base"

module MyServer
  module HttpAPI
    module ResourceController
      include MyServer::HttpAPI::ControllerBase
      extend self

      def get_resources(ctx)
        begin
          user = verify_token(ctx)
          people = People.get_all_people
          people_json = "[" + people.join(", ") { |p| p.to_json } + "]"
          publications = Publication.get_publications
          publications_json = "[" + publications.join(", ") { |p| p.to_json } + "]"
          files = MyFile.get_files
          files_json = "[" + files.join(", ") { |f| f.to_json } + "]"
          "{\"people\": #{people_json}, \"publications\": #{publications_json}, \"files\": #{files_json}}"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end
    end
  end
end
