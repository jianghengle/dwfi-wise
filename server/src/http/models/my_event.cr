module MyServer
  module HttpAPI
    class MyEvent < Crecto::Model
      schema "events" do
        field :title, String
        field :description, String
        field :status, String
        field :country, String
        field :state, String
        field :focus_area, String
        field :start_date, Time
        field :end_date, Time
        field :funding, String
        field :collaborators, String
        field :more_information, String
        field :point_of_contact, Int64
        field :website, String
        field :is_published, Bool
      end

      def to_json
        result = String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"title\":" << @title.to_json << ","
          str << "\"description\":" << @description.to_json << ","
          str << "\"status\":" << @status.to_json << ","
          str << "\"country\":" << @country.to_json << ","
          str << "\"state\":" << @state.to_json << ","
          str << "\"focusArea\":" << @focus_area.to_json << ","
          str << "\"startDate\":" << @start_date.as(Time).epoch << "," unless @start_date.nil?
          str << "\"endDate\":" << @end_date.as(Time).epoch << "," unless @end_date.nil?
          str << "\"funding\":" << @funding.to_json << ","
          str << "\"collaborators\":" << @collaborators.to_json << ","
          str << "\"moreInformation\":" << @more_information.to_json << ","
          str << "\"pointOfContact\":" << @point_of_contact.to_json << ","
          str << "\"website\":" << @website.to_json << ","
          str << "\"isPublished\":" << @is_published.to_json
          str << "}"
        end
        result
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
          str << "\"title\":" << @title.to_json << ","
          str << "\"description\":" << @description.to_json << ","
          str << "\"status\":" << @status.to_json << ","
          str << "\"country\":" << @country.to_json << ","
          str << "\"state\":" << @state.to_json << ","
          str << "\"focusArea\":" << @focus_area.to_json << ","
          str << "\"startDate\":\"" << @start_date.as(Time).to_s("%b %-d, %Y") << "\"," unless @start_date.nil?
          str << "\"endDate\":\"" << @end_date.as(Time).to_s("%b %-d, %Y") << "\"," unless @end_date.nil?
          str << "\"funding\":" << @funding.to_json << ","
          str << "\"collaborators\":" << @collaborators.to_json << ","
          str << "\"moreInformation\":" << @more_information.to_json << ","
          str << "\"pointOfContact\":" << @point_of_contact.to_json << ","
          str << "\"website\":" << @website.to_json << ","
          str << "\"people\": [" << (people.join(", ") { |p| p.to_json }) << "],"
          str << "\"grants\": [" << (grants.join(", ") { |g| g.to_json }) << "]"
          str << "}"
        end
      end

      def self.get_events
        items = Repo.all(MyEvent)
        return items.as(Array) unless items.nil?
        [] of MyEvent
      end

      def self.get_published_events(country = "")
        query = Query.where(is_published: "true")
        query.where(country: country) unless country.empty?
        items = Repo.all(MyEvent, query)
        return items.as(Array) unless items.nil?
        [] of MyEvent
      end

      def self.get_event(id)
        Repo.get(MyEvent, id)
      end

      def self.create_event(event, people, publications, files, grants)
        changeset = Repo.insert(event)
        raise changeset.errors.to_s unless changeset.valid?
        event_id = nil.as(Int64?)
        changeset.changes.each do |change|
          if (change.has_key?(:id))
            event_id = change[:id].as(Int64)
          end
        end
        raise "cannot get new id!" if event_id.nil?

        PeopleRelation.create_relations(people, "events", event_id)
        PublicationRelation.create_relations(publications, "events", event_id)
        FileRelation.create_relations(files, "events", event_id)
        GrantRelation.create_relations(grants, "events", event_id)
      end

      def self.update_event(event, people, publications, files, grants)
        changeset = Repo.update(event)
        raise changeset.errors.to_s unless changeset.valid?

        PeopleRelation.update_relations(people, "events", event.id)
        PublicationRelation.update_relations(publications, "events", event.id)
        FileRelation.update_relations(files, "events", event.id)
        GrantRelation.update_relations(grants, "events", event.id)
      end

      def self.delete_event(event_id)
        PeopleRelation.delete_relations("events", event_id)
        PublicationRelation.delete_relations("events", event_id)
        FileRelation.delete_relations("events", event_id)
        GrantRelation.delete_relations("events", event_id)

        event = Repo.get!(MyEvent, event_id)
        changeset = Repo.delete(event)
        raise changeset.errors.to_s unless changeset.valid?
      end
    end
  end
end
