module MyServer
  module HttpAPI
    class People < Crecto::Model
      schema "people" do
        field :first_name, String
        field :last_name, String
        field :credentials, String
        field :title, String
        field :employer, String
        field :dwfi_affiliation, String
        field :email, String
        field :phone, String
        field :website, String
      end

      def to_json
        String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"firstName\":" << @first_name.to_json << ","
          str << "\"lastName\":" << @last_name.to_json << ","
          str << "\"credentials\":" << @credentials.to_json << ","
          str << "\"title\":" << @title.to_json << ","
          str << "\"employer\":" << @employer.to_json << ","
          str << "\"dwfiAffiliation\":" << @dwfi_affiliation.to_json << ","
          str << "\"email\":" << @email.to_json << ","
          str << "\"phone\":" << @phone.to_json << ","
          str << "\"website\":" << @website.to_json
          str << "}"
        end
      end

      def self.get_all_people
        items = Repo.all(People)
        return items.as(Array) unless items.nil?
        [] of People
      end

      def self.get_one_people(id)
        Repo.get(People, id)
      end

      def self.create_people(people, files)
        changeset = Repo.insert(people)
        raise changeset.errors.to_s unless changeset.valid?
        people_id = nil.as(Int64?)
        changeset.changes.each do |change|
          if (change.has_key?(:id))
            people_id = change[:id].as(Int64)
          end
        end
        raise "cannot get new id!" if people_id.nil?

        FileRelation.create_relations(files, "people", people_id)
      end

      def self.update_people(people, files)
        changeset = Repo.update(people)
        raise changeset.errors.to_s unless changeset.valid?

        FileRelation.update_relations(files, "people", people.id)
      end

      def self.delete_people(people_id)
        FileRelation.delete_relations("people", people_id)
        PeopleRelation.delete_people_relations(people_id)

        people = Repo.get!(People, people_id)
        changeset = Repo.delete(people)
        raise changeset.errors.to_s unless changeset.valid?
      end
    end

    class PeopleRelation < Crecto::Model
      schema "people_relations" do
        field :people_id, Int64
        field :for_table, String
        field :for_id, Int64
        field :role, String
      end

      def to_json
        String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"peopleId\":" << @people_id << ","
          str << "\"forTable\":" << @for_table.to_json << ","
          str << "\"forId\":" << @for_id << ","
          str << "\"role\":" << @role.to_json
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
        relations = Repo.all(PeopleRelation, query)
        return [] of PeopleRelation if relations.nil?
        relations.as(Array)
      end

      def self.get_relation_map(for_table, ids)
        relation_map = Hash(String, Array(PeopleRelation)).new
        query = Query.where(for_table: for_table).where(:for_id, ids)
        relations = Repo.all(PeopleRelation, query)
        return relation_map if relations.nil?
        relations.as(Array).each do |r|
          id = r.for_id.to_s
          relation_map[id] = ([] of PeopleRelation) unless relation_map.has_key?(id)
          relation_map[id] << r
        end
        relation_map
      end

      def self.update_relations(relations, for_table, for_id)
        relations.each do |r|
          r.for_table = for_table
          r.for_id = for_id
          if (r.id)
            if (r.people_id.nil?)
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
        Repo.delete_all(PeopleRelation, query)
      end

      def self.delete_people_relations(people_id)
        query = Crecto::Repo::Query.new
        query.where(people_id: people_id)
        Repo.delete_all(PeopleRelation, query)
      end
    end
  end
end
