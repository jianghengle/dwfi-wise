module MyServer
  module HttpAPI
    class Publication < Crecto::Model
      schema "publications" do
        field :title, String
        field :authors, String
        field :abstract, String
        field :url, String
        field :status, String
        field :point_of_contact, Int64
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
          str << "\"pointOfContact\":" << @point_of_contact.to_json
          str << "}"
        end
        result
      end

      def self.get_publications
        items = Repo.all(Publication)
        return items.as(Array) unless items.nil?
        [] of Publication
      end

      def self.get_publication(id)
        Repo.get(Publication, id)
      end

      def self.create_publication(publication, files)
        changeset = Repo.insert(publication)
        raise changeset.errors.to_s unless changeset.valid?
        publication_id = nil.as(Int64?)
        changeset.changes.each do |change|
          if (change.has_key?(:id))
            publication_id = change[:id].as(Int64)
          end
        end
        raise "cannot get new id!" if publication_id.nil?

        FileRelation.create_relations(files, "publications", publication_id)
      end

      def self.update_publication(publication, files)
        changeset = Repo.update(publication)
        raise changeset.errors.to_s unless changeset.valid?

        FileRelation.update_relations(files, "publications", publication.id)
      end

      def self.delete_publication(publication_id)
        FileRelation.delete_relations("publications", publication_id)
        PublicationRelation.delete_publication_relations(publication_id)

        publication = Repo.get!(Publication, publication_id)
        changeset = Repo.delete(publication)
        raise changeset.errors.to_s unless changeset.valid?
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

      def self.delete_publication_relations(publication_id)
        query = Crecto::Repo::Query.new
        query.where(publication_id: publication_id)
        Repo.delete_all(PublicationRelation, query)
      end
    end
  end
end
