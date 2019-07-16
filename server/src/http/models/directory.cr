module MyServer
  module HttpAPI
    class Directory < Crecto::Model
      schema "directories" do
        field :people_id, Int64
        field :typ, String
        field :role, String
        field :tags, String
        field :institution, String
        field :department, String
        field :area, String
        field :specialty, String
      end

      def to_json(people)
        String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"peopleId\":" << @people_id << ","
          str << "\"firstName\":" << people.first_name.to_json << ","
          str << "\"lastName\":" << people.last_name.to_json << ","
          str << "\"typ\":" << @typ.to_json << ","
          str << "\"role\":" << @role.to_json << ","
          str << "\"tags\":" << @tags.to_json << ","
          str << "\"institution\":" << @institution.to_json << ","
          str << "\"department\":" << @department.to_json << ","
          str << "\"area\":" << @area.to_json << ","
          str << "\"specialty\":" << @specialty.to_json
          str << "}"
        end
      end

      def to_kumu_json(people)
        String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"peopleId\":" << @people_id << ","
          str << "\"Label\":" << (people.first_name.to_s + " " + people.last_name.to_s).to_json << ","
          str << "\"Type\":" << @typ.to_json << ","
          str << "\"Role\":" << @role.to_json << ","
          str << "\"Tags\":" << @tags.to_json << ","
          str << "\"Email\":" << people.email.to_json << ","
          str << "\"Institution\":" << @institution.to_json << ","
          str << "\"Department\":" << @department.to_json << ","
          str << "\"Title\":" << people.title.to_json << ","
          str << "\"Weblink\":" << people.website.to_json << ","
          str << "\"Phone\":" << people.phone.to_json << ","
          str << "\"Area\":" << @area.to_json << ","
          str << "\"Specialty\":" << @specialty.to_json
          str << "}"
        end
      end

      def self.get_directories
        items = Repo.all(Directory)
        return items.as(Array) unless items.nil?
        [] of Directory
      end

      def self.get_directory(id)
        Repo.get(Directory, id)
      end

      def self.create_directory(directory)
        changeset = Repo.insert(directory)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.update_directory(directory)
        changeset = Repo.update(directory)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.delete_directory(directory_id)
        directory = Repo.get!(Directory, directory_id)
        changeset = Repo.delete(directory)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.delete_directory_by_people_id(people_id)
        query = Query.where(people_id: people_id)
        Repo.delete_all(Directory, query)
      end
    end
  end
end
