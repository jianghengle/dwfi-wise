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
        result = String.build do |str|
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
          str << "\"website\":" << @website.to_json << ","
          str << "\"createdAt\":" << @created_at.as(Time).epoch << ","
          str << "\"updatedAt\":" << @updated_at.as(Time).epoch
          str << "}"
        end
        result
      end

      def self.get_all_people
        items = Repo.all(People)
        return items.as(Array) unless items.nil?
        [] of People
      end
    end

    class PeopleRelation < Crecto::Model
      schema "people_relation" do
        field :people_id, Int64
        field :for_table, String
        field :for_id, Int64
        field :role, String
      end
    end
  end
end
