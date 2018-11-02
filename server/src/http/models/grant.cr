module MyServer
  module HttpAPI
    class Grant < Crecto::Model
      schema "grants" do
        field :organization, String
      end

      def to_json
        result = String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"organization\":" << @organization.to_json
          str << "}"
        end
        result
      end

      def self.get_grants
        items = Repo.all(Grant)
        return items.as(Array) unless items.nil?
        [] of Grant
      end

      def self.get_grant(id)
        Repo.get(Grant, id)
      end

      def self.create_grant(grant)
        changeset = Repo.insert(grant)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.update_grant(grant)
        changeset = Repo.update(grant)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.delete_grant(grant_id)
        GrantRelation.delete_grant_relations(grant_id)

        grant = Repo.get!(Grant, grant_id)
        changeset = Repo.delete(grant)
        raise changeset.errors.to_s unless changeset.valid?
      end
    end

    class GrantRelation < Crecto::Model
      schema "grant_relations" do
        field :grant_id, Int64
        field :for_table, String
        field :for_id, Int64
        field :comment, String
      end

      def to_json
        String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"grantId\":" << @grant_id << ","
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
        relations = Repo.all(GrantRelation, query)
        return [] of GrantRelation if relations.nil?
        relations.as(Array)
      end

      def self.get_relation_map(for_table, ids)
        relation_map = Hash(String, Array(GrantRelation)).new
        query = Query.where(for_table: for_table).where(:for_id, ids)
        relations = Repo.all(GrantRelation, query)
        return relation_map if relations.nil?
        relations.as(Array).each do |r|
          id = r.for_id.to_s
          relation_map[id] = ([] of GrantRelation) unless relation_map.has_key?(id)
          relation_map[id] << r
        end
        relation_map
      end

      def self.update_relations(relations, for_table, for_id)
        relations.each do |r|
          r.for_table = for_table
          r.for_id = for_id
          if (r.id)
            if (r.grant_id.nil?)
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
        Repo.delete_all(GrantRelation, query)
      end

      def self.delete_grant_relations(grant_id)
        query = Crecto::Repo::Query.new
        query.where(grant_id: grant_id)
        Repo.delete_all(GrantRelation, query)
      end
    end
  end
end
