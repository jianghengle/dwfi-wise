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

    class PublicationRelation < Crecto::Model
      schema "publication_relations" do
        field :publication_id, Int64
        field :for_table, String
        field :for_id, Int64
        field :comment, String
      end

      def to_json
        String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"publicationId\":" << @publication_id << ","
          str << "\"forTable\":" << @for_table.to_json << ","
          str << "\"forId\":" << @for_id << ","
          str << "\"comment\":" << @comment.to_json
          str << "}"
        end
      end

      def self.create_relations(relations, for_table, for_id)
        relations.each do |r|
          r.for_table = for_table
          r.for_id = for_id
          changeset = Repo.insert(r)
          raise changeset.errors.to_s unless changeset.valid?
        end
      end

      def self.get_relations(for_table, for_id)
        query = Crecto::Repo::Query.new
        query.where(for_table: for_table).where(for_id: for_id)
        relations = Repo.all(PublicationRelation, query)
        return [] of PublicationRelation if relations.nil?
        relations.as(Array)
      end

      def self.update_relations(relations, for_table, for_id)
        relations.each do |r|
          r.for_table = for_table
          r.for_id = for_id
          if (r.id)
            if (r.publication_id.nil?)
              changeset = Repo.delete(r)
              raise changeset.errors.to_s unless changeset.valid?
            else
              changeset = Repo.update(r)
              raise changeset.errors.to_s unless changeset.valid?
            end
          else
            changeset = Repo.insert(r)
            raise changeset.errors.to_s unless changeset.valid?
          end
        end
      end

      def self.delete_relations(for_table, for_id)
        query = Crecto::Repo::Query.new
        query.where(for_table: for_table).where(for_id: for_id)
        Repo.delete_all(PublicationRelation, query)
      end
    end
  end
end
