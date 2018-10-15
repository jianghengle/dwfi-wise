module MyServer
  module HttpAPI
    class VisitingScholar < Crecto::Model
      schema "visiting_scholars" do
        field :first_name, String
        field :last_name, String
        field :country, String
        field :state, String
        field :research_topic, String
        field :description, String
        field :status, String
        field :focus_area, String
        field :start_date, Time
        field :end_date, Time
        field :funding, String
        field :collaborators, String
        field :more_information, String
        field :point_of_contact, String
        field :is_published, Bool
      end

      def to_json
        result = String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"firstName\":" << @first_name.to_json << ","
          str << "\"lastName\":" << @last_name.to_json << ","
          str << "\"country\":" << @country.to_json << ","
          str << "\"state\":" << @state.to_json << ","
          str << "\"researchTopic\":" << @research_topic.to_json << ","
          str << "\"description\":" << @description.to_json << ","
          str << "\"status\":" << @status.to_json << ","
          str << "\"focusArea\":" << @focus_area.to_json << ","
          str << "\"startDate\":" << @start_date.as(Time).epoch << "," unless @start_date.nil?
          str << "\"endDate\":" << @end_date.as(Time).epoch << "," unless @end_date.nil?
          str << "\"funding\":" << @funding.to_json << ","
          str << "\"collaborators\":" << @collaborators.to_json << ","
          str << "\"moreInformation\":" << @more_information.to_json << ","
          str << "\"pointOfContact\":" << @point_of_contact.to_json << ","
          str << "\"isPublished\":" << @is_published.to_json << ","
          str << "\"createdAt\":" << @created_at.as(Time).epoch << ","
          str << "\"updatedAt\":" << @updated_at.as(Time).epoch
          str << "}"
        end
        result
      end

      def self.get_visiting_scholars
        items = Repo.all(VisitingScholar)
        return items.as(Array) unless items.nil?
        [] of VisitingScholar
      end
    end
  end
end
