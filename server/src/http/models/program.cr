module MyServer
  module HttpAPI
    class Program < Crecto::Model
      schema "programs" do
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
        field :request, String
        field :progress, String
        field :progress_time, Time
      end

      def to_json
        String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"title\":" << @title.to_json << ","
          str << "\"description\":" << @description.to_json << ","
          str << "\"status\":" << @status.to_json << ","
          str << "\"country\":" << @country.to_json << ","
          str << "\"state\":" << @state.to_json << ","
          str << "\"focusArea\":" << @focus_area.to_json << ","
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
      end

      def to_json_for_count(grants, people)
        String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"country\":" << @country.to_json << ","
          str << "\"focusArea\":" << @focus_area.to_json << ","
          str << "\"people\":" << "[" << (people.join(", ") { |p| p.people_id.to_s }) << "]" << ","
          str << "\"grants\":" << "[" << (grants.join(", ") { |g| g.grant_id.to_s }) << "]"
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

      def self.get_programs
        items = Repo.all(Program)
        return items.as(Array) unless items.nil?
        [] of Program
      end

      def self.get_published_programs(country = "")
        query = Query.where(is_published: "true")
        query.where("country LIKE ?", "%#{country}%") unless country.empty?
        items = Repo.all(Program, query)
        return items.as(Array) unless items.nil?
        [] of Program
      end

      def self.get_project_program_map(projects)
        program_ids = [] of String
        projects.each { |p| program_ids << p.program_id.to_s unless p.program_id.nil? }
        project_program_map = Hash(String, String).new
        query = Query.where(:id, program_ids)
        programs = Repo.all(Program, query)
        return project_program_map if programs.nil?
        program_map = Hash(String, Program).new
        programs.as(Array).each do |p|
          program_map[p.id.to_s] = p
        end
        projects.each do |p|
          project_id = p.id.to_s
          program_id = p.program_id.to_s
          program_title = ""
          program_title = program_map[program_id].title.to_s if program_map.has_key?(program_id)
          project_program_map[project_id] = program_title
        end
        project_program_map
      end

      def self.get_program(id)
        Repo.get(Program, id)
      end

      def self.create_program(program, people, publications, files, grants)
        changeset = Repo.insert(program)
        raise changeset.errors.to_s unless changeset.valid?
        program_id = nil.as(Int64?)
        changeset.changes.each do |change|
          if (change.has_key?(:id))
            program_id = change[:id].as(Int64)
          end
        end
        raise "cannot get new id!" if program_id.nil?

        PeopleRelation.create_relations(people, "programs", program_id)
        PublicationRelation.create_relations(publications, "programs", program_id)
        FileRelation.create_relations(files, "programs", program_id)
        GrantRelation.create_relations(grants, "programs", program_id)
      end

      def self.update_program(program, people, publications, files, grants)
        changeset = Repo.update(program)
        raise changeset.errors.to_s unless changeset.valid?

        PeopleRelation.update_relations(people, "programs", program.id)
        PublicationRelation.update_relations(publications, "programs", program.id)
        FileRelation.update_relations(files, "programs", program.id)
        GrantRelation.update_relations(grants, "programs", program.id)
      end

      def self.update_requested_program(program, publications, files, grants)
        changeset = Repo.update(program)
        raise changeset.errors.to_s unless changeset.valid?

        PublicationRelation.update_relations(publications, "programs", program.id)
        FileRelation.update_relations(files, "programs", program.id)
        GrantRelation.update_relations(grants, "programs", program.id)
      end

      def self.delete_program(program_id)
        PeopleRelation.delete_relations("programs", program_id)
        PublicationRelation.delete_relations("programs", program_id)
        FileRelation.delete_relations("programs", program_id)
        GrantRelation.delete_relations("programs", program_id)

        Project.null_project_program(program_id)

        program = Repo.get!(Program, program_id)
        changeset = Repo.delete(program)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.export_programs(ids)
        query = Query.where(:id, ids)
        programs = Repo.all(Program, query)
        return "[]" if programs.nil?
        result = programs.as(Array).join(",") do |p|
          info = p.id.to_s + ", " + p.title.to_s
          "[" + p.id.to_s + "," + info.to_json + "]"
        end
        "[" + result + "]"
      end

      def self.request_program_update(id, request, user)
        program = Repo.get(Program, id)
        program = program.as(Program)
        if request
          if program.request.to_s.empty?
            program.request = Random::Secure.hex(24).to_s
            changeset = Repo.update(program)
            raise changeset.errors.to_s unless changeset.valid?
          end
          Program.send_request_email(program, user)
        else
          unless program.request.to_s.empty?
            program.request = ""
            changeset = Repo.update(program)
            raise changeset.errors.to_s unless changeset.valid?
          end
        end
      end

      def self.get_program_by_key(key)
        raise "empty key" if key.empty?
        query = Query.where(request: key)
        items = Repo.all(Program, query)
        raise "cannot find program" if items.nil?
        items = items.as(Array)
        raise "cannot find program" if items.empty?
        items[0]
      end

      def self.get_program_people(program)
        people_relations = PeopleRelation.get_relations("programs", program.id)
        return [] of People if people_relations.empty?
        people_ids = people_relations.map { |i| i.people_id }
        People.get_people_map(people_ids).values
      end

      def self.send_request_email(program, user)
        return unless (ENV.has_key?("EMAIL_USERNAME") && ENV.has_key?("EMAIL_PASSWORD"))
        email_username = ENV["EMAIL_USERNAME"]
        email_password = ENV["EMAIL_PASSWORD"]

        people = Program.get_program_people(program)
        return if people.empty?

        # Create email message
        link = "https://glodet.nebraska.edu:4000/index.html#/requested/program/#{program.request.to_s}"
        create_program_link = "https://glodet.nebraska.edu:4000/index.html#/request_new_program/program/#{program.request.to_s}"
        create_project_link = "https://glodet.nebraska.edu:4000/index.html#/request_new_project/program/#{program.request.to_s}"

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
            mail.subject "Update Program in UNDA Database"
            mail.to p.email.to_s

            mail.message_html <<-EOM
              <html>
              <body>
              <p>Dear #{p.first_name.to_s},</p>

              <p>
              Our records indicate that you are associated with the program #{program.title.to_s} in the UNDA database.
              Please open this <a href=\"#{link}\">link</a> below in your browser to review, and if needed update, the information associated with your program.
              </p>

              <p>
              The UNDA database showcases the work of the University of Nebraska towards the vision of a water and food secure world, and includes work by DWFI, Faculty Fellows, the Nebraska Water Center, the Water Sciences Laboratory, and associated staff and scholars.  High-level information about each program, including description, focus area, status, start and end dates, country, and people involved is displayed on an interactive map on the DWFI website.  Each Faculty involved will have a link out to his or her department research website.  In addition, DWFI uses the UNDA database to collect quarterly program updates to share with the Robert B. Daugherty Foundation and our Board of Directors.
              </p>

              <p>
              You can view the interactive map here: <a href=\"https://waterforfood.nebraska.edu/our-work\">https://waterforfood.nebraska.edu/our-work</a>.
              </p>

              <p>
              To add a new program or a project to a map, please complete these forms: <br />
              <a href=\"#{create_program_link}\">New Program</a> <br />
              <a href=\"#{create_project_link}\">New Project</a> <br />
              </p>

              <p>
              Questions or comments may be directed to Lacey Bodnar, Research Project Manager, at <a href=\"mailto:lbodnar@nebraska.edu\">lbodnar@nebraska.edu</a>.
              </p>

              <p>Thank you,</p>

              <footer>
              DWFI <br />
              <img src=\"https://glodet.nebraska.edu:4000/dwfi_logo.png\" />
              </footer>

              </body>
              </html>
              EOM

            # Enqueue the email to sender
            enqueue mail
          end
        end
      end
    end
  end
end
