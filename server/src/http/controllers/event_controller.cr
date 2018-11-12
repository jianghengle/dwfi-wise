require "./controller_base"

module MyServer
  module HttpAPI
    module EventController
      include MyServer::HttpAPI::ControllerBase
      extend self

      def get_events(ctx)
        begin
          user = verify_token(ctx)
          items = MyEvent.get_events
          "[" + (items.join(", ") { |i| i.to_json }) + "]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def get_event(ctx)
        begin
          user = verify_token(ctx)
          id = get_param!(ctx, "id").to_i
          event = MyEvent.get_event(id)
          people_relations = PeopleRelation.get_relations("events", id)
          people_relations_json = "[" + people_relations.join(", ") { |r| r.to_json } + "]"
          publication_relations = PublicationRelation.get_relations("events", id)
          publication_relations_json = "[" + publication_relations.join(", ") { |r| r.to_json } + "]"
          file_relations = FileRelation.get_relations("events", id)
          file_relations_json = "[" + file_relations.join(", ") { |r| r.to_json } + "]"
          grant_relations = GrantRelation.get_relations("events", id)
          grant_relations_json = "[" + grant_relations.join(", ") { |r| r.to_json } + "]"
          "[ #{event.to_json}, #{people_relations_json}, #{publication_relations_json}, #{file_relations_json}, #{grant_relations_json}]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def create_event(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          event = MyEvent.new
          event.title = get_param!(ctx, "title")
          event.description = get_param!(ctx, "description")
          event.status = get_param!(ctx, "status")
          event.country = get_param!(ctx, "country")
          event.state = get_param!(ctx, "state")
          event.focus_area = get_param!(ctx, "focusArea")
          start_date = get_param!(ctx, "startDate")
          event.start_date = Time.epoch(start_date.to_i) unless start_date == ""
          end_date = get_param!(ctx, "endDate")
          event.end_date = Time.epoch(end_date.to_i) unless end_date == ""
          event.funding = get_param!(ctx, "funding")
          event.collaborators = get_param!(ctx, "collaborators")
          event.more_information = get_param!(ctx, "moreInformation")
          point_of_contact = get_param!(ctx, "pointOfContact")
          event.point_of_contact = point_of_contact.to_i unless point_of_contact == ""
          event.website = get_param!(ctx, "website")
          event.is_published = get_param!(ctx, "isPublished") == "true"

          people = Array(PeopleRelation).from_json(get_param!(ctx, "people"))
          publications = Array(PublicationRelation).from_json(get_param!(ctx, "publications"))
          files = Array(FileRelation).from_json(get_param!(ctx, "files"))
          grants = Array(GrantRelation).from_json(get_param!(ctx, "grants"))

          MyEvent.create_event(event, people, publications, files, grants)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def update_event(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          event = MyEvent.new
          event.id = get_param!(ctx, "id").to_i
          event.title = get_param!(ctx, "title")
          event.description = get_param!(ctx, "description")
          event.status = get_param!(ctx, "status")
          event.country = get_param!(ctx, "country")
          event.state = get_param!(ctx, "state")
          event.focus_area = get_param!(ctx, "focusArea")
          start_date = get_param!(ctx, "startDate")
          event.start_date = Time.epoch(start_date.to_i) unless start_date == ""
          end_date = get_param!(ctx, "endDate")
          event.end_date = Time.epoch(end_date.to_i) unless end_date == ""
          event.funding = get_param!(ctx, "funding")
          event.collaborators = get_param!(ctx, "collaborators")
          event.more_information = get_param!(ctx, "moreInformation")
          point_of_contact = get_param!(ctx, "pointOfContact")
          event.point_of_contact = point_of_contact.to_i unless point_of_contact == ""
          event.website = get_param!(ctx, "website")
          event.is_published = get_param!(ctx, "isPublished") == "true"

          people = Array(PeopleRelation).from_json(get_param!(ctx, "people"))
          publications = Array(PublicationRelation).from_json(get_param!(ctx, "publications"))
          files = Array(FileRelation).from_json(get_param!(ctx, "files"))
          grants = Array(GrantRelation).from_json(get_param!(ctx, "grants"))

          MyEvent.update_event(event, people, publications, files, grants)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def delete_event(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          event_id = get_param!(ctx, "eventId").to_i
          MyEvent.delete_event(event_id)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def count_events_for_map(ctx)
        begin
          items = MyEvent.get_published_events
          ids = items.map { |i| i.id }
          relation_map = GrantRelation.get_relation_map("events", ids)
          str = items.join(", ") do |i|
            grants = [] of GrantRelation
            grants = relation_map[i.id.to_s] if relation_map.has_key?(i.id.to_s)
            i.to_json_for_count(grants)
          end
          "[#{str}]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def get_events_for_map(ctx)
        begin
          country = URI.unescape(get_param!(ctx, "country"))
          items = MyEvent.get_published_events(country)
          ids = items.map { |i| i.id }
          people_relation_map = PeopleRelation.get_relation_map("events", ids)
          grant_relation_map = GrantRelation.get_relation_map("events", ids)
          str = items.join(", ") do |i|
            id = i.id.to_s
            people = [] of PeopleRelation
            people = people_relation_map[id] if people_relation_map.has_key?(id)
            grants = [] of GrantRelation
            grants = grant_relation_map[id] if grant_relation_map.has_key?(id)
            i.to_json_for_map(people, grants)
          end
          "[#{str}]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end
    end
  end
end
