module MyServer
  module HttpAPI
    class Project < Crecto::Model
      schema "projects" do
        field :title, String
        field :description, String
        field :status, String
        field :country, String
        field :state, String
        field :focus_area, String
        field :program_id, Int64
        field :start_date, Time
        field :end_date, Time
        field :funding, String
        field :collaborators, String
        field :more_information, String
        field :point_of_contact, Int64
        field :website, String
        field :is_published, Bool
        field :request, String
        field :progress, String
        field :progress_time, Time
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
          str << "\"programId\":" << @program_id.to_json << ","
          str << "\"startDate\":" << @start_date.as(Time).to_unix << "," unless @start_date.nil?
          str << "\"endDate\":" << @end_date.as(Time).to_unix << "," unless @end_date.nil?
          str << "\"funding\":" << @funding.to_json << ","
          str << "\"collaborators\":" << @collaborators.to_json << ","
          str << "\"moreInformation\":" << @more_information.to_json << ","
          str << "\"pointOfContact\":" << @point_of_contact.to_json << ","
          str << "\"website\":" << @website.to_json << ","
          str << "\"request\":" << @request.to_json << ","
          str << "\"progress\":" << @progress.to_json << ","
          str << "\"progressTime\":" << @progress_time.as(Time).to_unix << "," unless @progress_time.nil?
          str << "\"isPublished\":" << @is_published.to_json
          str << "}"
        end
        result
      end

      def to_json_for_count(grands, people)
        String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"country\":" << @country.to_json << ","
          str << "\"focusArea\":" << @focus_area.to_json << ","
          str << "\"people\":" << "[" << (people.join(", ") { |p| p.people_id.to_s }) << "]" << ","
          str << "\"grants\":" << "[" << (grands.join(", ") { |g| g.grant_id.to_s }) << "]"
          str << "}"
        end
      end

      def to_json_for_map(people, grants, program_title)
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
          str << "\"grants\": [" << (grants.join(", ") { |g| g.to_json }) << "],"
          str << "\"programTitle\":" << program_title.to_json
          str << "}"
        end
      end

      def self.get_projects
        items = Repo.all(Project)
        return items.as(Array) unless items.nil?
        [] of Project
      end

      def self.get_published_projects(country = "")
        query = Query.where(is_published: "true")
        query.where("country LIKE ?", "%#{country}%") unless country.empty?
        items = Repo.all(Project, query)
        return items.as(Array) unless items.nil?
        [] of Project
      end

      def self.get_project(id)
        Repo.get(Project, id)
      end

      def self.create_project(project, people, publications, files, grants)
        changeset = Repo.insert(project)
        raise changeset.errors.to_s unless changeset.valid?
        project_id = nil.as(Int64?)
        changeset.changes.each do |change|
          if (change.has_key?(:id))
            project_id = change[:id].as(Int64)
          end
        end
        raise "cannot get new id!" if project_id.nil?

        PeopleRelation.create_relations(people, "projects", project_id)
        PublicationRelation.create_relations(publications, "projects", project_id)
        FileRelation.create_relations(files, "projects", project_id)
        GrantRelation.create_relations(grants, "projects", project_id)
      end

      def self.update_project(project, people, publications, files, grants)
        changeset = Repo.update(project)
        raise changeset.errors.to_s unless changeset.valid?

        PeopleRelation.update_relations(people, "projects", project.id)
        PublicationRelation.update_relations(publications, "projects", project.id)
        FileRelation.update_relations(files, "projects", project.id)
        GrantRelation.update_relations(grants, "projects", project.id)
      end

      def self.update_requested_project(project, publications, files, grants)
        changeset = Repo.update(project)
        raise changeset.errors.to_s unless changeset.valid?

        PublicationRelation.update_relations(publications, "projects", project.id)
        FileRelation.update_relations(files, "projects", project.id)
        GrantRelation.update_relations(grants, "projects", project.id)
      end

      def self.delete_project(project_id)
        PeopleRelation.delete_relations("projects", project_id)
        PublicationRelation.delete_relations("projects", project_id)
        FileRelation.delete_relations("projects", project_id)
        GrantRelation.delete_relations("projects", project_id)

        project = Repo.get!(Project, project_id)
        changeset = Repo.delete(project)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.null_project_program(program_id)
        query = Crecto::Repo::Query.where(program_id: program_id)
        Repo.update_all(Project, query, {program_id: nil})
      end

      def self.request_project_update(id, request, user)
        project = Repo.get(Project, id)
        project = project.as(Project)
        if request
          if project.request.to_s.empty?
            project.request = Random::Secure.hex(24).to_s
            changeset = Repo.update(project)
            raise changeset.errors.to_s unless changeset.valid?
          end
          Project.send_request_email(project, user)
        else
          unless project.request.to_s.empty?
            project.request = ""
            changeset = Repo.update(project)
            raise changeset.errors.to_s unless changeset.valid?
          end
        end
      end

      def self.get_project_by_key(key)
        raise "empty key" if key.empty?
        query = Query.where(request: key)
        items = Repo.all(Project, query)
        raise "cannot find project" if items.nil?
        items = items.as(Array)
        raise "cannot find project" if items.empty?
        items[0]
      end

      def self.get_project_people(project)
        people_relations = PeopleRelation.get_relations("projects", project.id)
        return [] of People if people_relations.empty?
        people_ids = people_relations.map { |i| i.people_id }
        People.get_people_map(people_ids).values
      end

      def self.send_request_email(project, user)
        return unless (ENV.has_key?("EMAIL_USERNAME") && ENV.has_key?("EMAIL_PASSWORD"))
        email_username = ENV["EMAIL_USERNAME"]
        email_password = ENV["EMAIL_PASSWORD"]

        people = Project.get_project_people(project)
        return if people.empty?

        # Create email message
        link = "https://glodet.nebraska.edu:4000/index.html#/requested/project/#{project.request.to_s}"
        create_program_link = "https://glodet.nebraska.edu:4000/index.html#/request_new_program/project/#{project.request.to_s}"
        create_project_link = "https://glodet.nebraska.edu:4000/index.html#/request_new_project/project/#{project.request.to_s}"

        # Set SMTP client configuration
        config = EMail::Client::Config.new("hcc.unl.edu", 25)
        config.use_tls
        config.openssl_verify_mode = OpenSSL::SSL::VerifyMode::NONE
        config.use_auth(email_username, email_password)
        config.logger = Logger.new(STDOUT)

        # Create concurrent sender object
        sender = EMail::ConcurrentSender.new(config)

        # Sending emails with concurrently 3 connections.
        sender.number_of_connections = 3

        # Sending max 10 emails by 1 connection.
        sender.messages_per_connection = 10

        # Start email sending.
        sender.start do
          # In this block, default receiver is sender
          people.each do |p|
            next if (p.email.nil? || p.email.to_s.empty?)

            # Create email message
            mail = EMail::Message.new
            mail.from "support@hcc.unl.edu"
            mail.subject "Update Project in UNDA Database"
            mail.to p.email.to_s
            mail.message <<-EOM
              Dear #{p.first_name.to_s},

              Our records indicate that you are associated with the project #{project.title} in the UNDA database.
              Please open the link below in your browser to review, and if needed update, the information associated with your project.
              #{link}

              The UNDA database showcases the work of the University of Nebraska towards the vision of a water and food secure world, and includes work by DWFI, Faculty Fellows, the Nebraska Water Center, the Water Sciences Laboratory, and associated staff and scholars.  High-level information about each project, including description, focus area, status, start and end dates, country, and people involved is displayed on an interactive map on the DWFI website.  Each Faculty involved will have a link out to his or her department research website.  In addition, DWFI uses the UNDA database to collect quarterly project updates to share with the Robert B. Daugherty Foundation and our Board of Directors.

              You can view the interactive map here: https://waterforfood.nebraska.edu/our-work.

              Questions or comments may be directed to Lacey Bodnar, Research Project Manager, at lbodnar@nebraska.edu.

              Thank you,
              DWFI
              EOM

            # Enqueue the email to sender
            enqueue mail
          end
        end
      end
    end
  end
end
