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
        field :point_of_contact, String
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

      def self.get_programs
        items = Repo.all(Program)
        return items.as(Array) unless items.nil?
        [] of Program
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
    end
  end
end
