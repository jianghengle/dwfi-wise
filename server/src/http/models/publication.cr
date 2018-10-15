module MyServer
  module HttpAPI
    class Publication < Crecto::Model
      schema "publications" do
        field :title, String
        field :authors, String
        field :abstract, String
        field :url, String
        field :status, String
        field :point_of_contact, String
      end

      def to_json
        result = String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"title\":" << @title.to_json << ","
          str << "\"authors\":" << @authors.to_json << ","
          str << "\"abstract\":" << @abstract.to_json << ","
          str << "\"url\":" << @url.to_json << ","
          str << "\"status\":" << @status.to_json << ","
          str << "\"pointOfContact\":" << @point_of_contact.to_json << ","
          str << "\"createdAt\":" << @created_at.as(Time).epoch << ","
          str << "\"updatedAt\":" << @updated_at.as(Time).epoch
          str << "}"
        end
        result
      end

      def self.get_publications
        items = Repo.all(Publication)
        return items.as(Array) unless items.nil?
        [] of Publication
      end
    end
  end
end
