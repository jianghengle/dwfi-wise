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
        field :point_of_contact, Int64
        field :is_published, Bool
      end

      def to_json
        String.build do |str|
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
          str << "\"isPublished\":" << @is_published.to_json
          str << "}"
        end
      end

      def to_json_for_count(grands)
        String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"country\":" << @country.to_json << ","
          str << "\"focusArea\":" << @focus_area.to_json << ","
          str << "\"grants\":" << "[" << (grands.join(", ") { |g| g.grant_id.to_s }) << "]"
          str << "}"
        end
      end

      def to_json_for_map(people, grants)
        String.build do |str|
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
          str << "\"people\": [" << (people.join(", ") { |p| p.to_json }) << "],"
          str << "\"grants\": [" << (grants.join(", ") { |g| g.to_json }) << "]"
          str << "}"
        end
      end

      def self.get_visiting_scholars
        items = Repo.all(VisitingScholar)
        return items.as(Array) unless items.nil?
        [] of VisitingScholar
      end

      def self.get_published_visiting_scholars(country = "")
        query = Query.where(is_published: "true")
        query.where(country: country) unless country.empty?
        items = Repo.all(VisitingScholar, query)
        return items.as(Array) unless items.nil?
        [] of VisitingScholar
      end

      def self.get_visiting_scholar(id)
        Repo.get(VisitingScholar, id)
      end

      def self.create_visiting_scholar(visiting_scholar, people, publications, files, grants)
        changeset = Repo.insert(visiting_scholar)
        raise changeset.errors.to_s unless changeset.valid?
        visiting_scholar_id = nil.as(Int64?)
        changeset.changes.each do |change|
          if (change.has_key?(:id))
            visiting_scholar_id = change[:id].as(Int64)
          end
        end
        raise "cannot get new id!" if visiting_scholar_id.nil?

        PeopleRelation.create_relations(people, "visiting_scholars", visiting_scholar_id)
        PublicationRelation.create_relations(publications, "visiting_scholars", visiting_scholar_id)
        FileRelation.create_relations(files, "visiting_scholars", visiting_scholar_id)
        GrantRelation.create_relations(grants, "visiting_scholars", visiting_scholar_id)
      end

      def self.update_visiting_scholar(visiting_scholar, people, publications, files, grants)
        changeset = Repo.update(visiting_scholar)
        raise changeset.errors.to_s unless changeset.valid?

        PeopleRelation.update_relations(people, "visiting_scholars", visiting_scholar.id)
        PublicationRelation.update_relations(publications, "visiting_scholars", visiting_scholar.id)
        FileRelation.update_relations(files, "visiting_scholars", visiting_scholar.id)
        GrantRelation.update_relations(grants, "visiting_scholars", visiting_scholar.id)
      end

      def self.delete_visiting_scholar(visiting_scholar_id)
        PeopleRelation.delete_relations("visiting_scholars", visiting_scholar_id)
        PublicationRelation.delete_relations("visiting_scholars", visiting_scholar_id)
        FileRelation.delete_relations("visiting_scholars", visiting_scholar_id)
        GrantRelation.delete_relations("visiting_scholars", visiting_scholar_id)

        visiting_scholar = Repo.get!(VisitingScholar, visiting_scholar_id)
        changeset = Repo.delete(visiting_scholar)
        raise changeset.errors.to_s unless changeset.valid?
      end
    end
  end
end
