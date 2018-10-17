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
          str << "\"programId\":" << @program_id.to_json << ","
          str << "\"startAate\":" << @start_date.as(Time).epoch << "," unless @start_date.nil?
          str << "\"endAate\":" << @end_date.as(Time).epoch << "," unless @end_date.nil?
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

      def self.get_projects
        items = Repo.all(Project)
        return items.as(Array) unless items.nil?
        [] of Project
      end

      def self.get_project(id)
        Repo.get(Project, id)
      end

      def self.create_project(project, people, publications, files)
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
      end

      def self.update_project(project, people, publications, files)
        changeset = Repo.update(project)
        raise changeset.errors.to_s unless changeset.valid?

        PeopleRelation.update_relations(people, "projects", project.id)
        PublicationRelation.update_relations(publications, "projects", project.id)
        FileRelation.update_relations(files, "projects", project.id)
      end

      def self.delete_project(project_id)
        PeopleRelation.delete_relations("projects", project_id)
        PublicationRelation.delete_relations("projects", project_id)
        FileRelation.delete_relations("projects", project_id)

        project = Repo.get!(Project, project_id)
        changeset = Repo.delete(project)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.null_project_program(program_id)
        query = Crecto::Repo::Query.where(program_id: program_id)
        Repo.update_all(Project, query, {program_id: nil})
      end
    end
  end
end
