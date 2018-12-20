module MyServer
  module HttpAPI
    class Faculty < Crecto::Model
      schema "faculty" do
        field :people_id, Int64
        field :year_joined, Int64
        field :status, String
        field :campus, String
        field :department, String
        field :area_of_expertise, String
        field :expertise_title, String
      end

      def to_json(people)
        String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"peopleId\":" << @people_id << ","
          str << "\"firstName\":" << people.first_name.to_json << ","
          str << "\"lastName\":" << people.last_name.to_json << ","
          str << "\"yearJoined\":" << @year_joined.to_json << ","
          str << "\"status\":" << @status.to_json << ","
          str << "\"campus\":" << @campus.to_json << ","
          str << "\"department\":" << @department.to_json << ","
          str << "\"areaOfExpertise\":" << @area_of_expertise.to_json << ","
          str << "\"expertiseTitle\":" << @expertise_title.to_json
          str << "}"
        end
      end

      def self.get_all_faculty
        items = Repo.all(Faculty)
        return items.as(Array) unless items.nil?
        [] of Faculty
      end

      def self.get_one_faculty(id)
        Repo.get(Faculty, id)
      end

      def self.create_faculty(faculty, work_plans)
        changeset = Repo.insert(faculty)
        raise changeset.errors.to_s unless changeset.valid?
        faculty_id = nil.as(Int64?)
        changeset.changes.each do |change|
          if (change.has_key?(:id))
            faculty_id = change[:id].as(Int64)
          end
        end
        raise "cannot get new id!" if faculty_id.nil?

        WorkPlan.create_work_plans(work_plans, faculty_id)
      end

      def self.update_faculty(faculty, work_plans)
        changeset = Repo.update(faculty)
        raise changeset.errors.to_s unless changeset.valid?

        WorkPlan.update_work_plans(work_plans)
      end

      def self.delete_faculty(faculty_id)
        WorkPlan.delete_work_plans(faculty_id)

        faculty = Repo.get!(Faculty, faculty_id)
        changeset = Repo.delete(faculty)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.delete_faculty_by_people_id(people_id)
        query = Query.where(people_id: people_id)
        faculty = Repo.all(Faculty, query)
        return if faculty.nil?
        faculty.as(Array).each do |f|
          Faculty.delete_faculty(f.id)
        end
      end
    end

    class WorkPlan < Crecto::Model
      schema "work_plans" do
        field :faculty_id, Int64
        field :year, Int64
        field :plan, String
      end

      def to_json
        String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"facultyId\":" << @faculty_id << ","
          str << "\"year\":" << @year << ","
          str << "\"plan\":" << @plan.to_json
          str << "}"
        end
      end

      def self.get_work_plans(faculty_id)
        query = Query.where(faculty_id: faculty_id)
        items = Repo.all(WorkPlan, query)
        return [] of WorkPlan if items.nil?
        items.as(Array)
      end

      def self.create_work_plans(work_plans, faculty_id)
        work_plans.each do |w|
          w.faculty_id = faculty_id
          changeset = Repo.insert(w)
          raise changeset.errors.to_s unless changeset.valid?
        end
      end

      def self.update_work_plans(work_plans)
        work_plans.each do |w|
          if (w.id)
            if (w.faculty_id.nil?)
              changeset = Repo.delete(w)
              raise changeset.errors.to_s unless changeset.valid?
            else
              changeset = Repo.update(w)
              raise changeset.errors.to_s unless changeset.valid?
            end
          else
            changeset = Repo.insert(w)
            raise changeset.errors.to_s unless changeset.valid?
          end
        end
      end

      def self.delete_work_plans(faculty_id)
        query = Query.where(faculty_id: faculty_id)
        Repo.delete_all(WorkPlan, query)
      end

      def self.export_work_plans(faculty_ids)
        query = Query.where(:faculty_id, faculty_ids)
        work_plans = Repo.all(WorkPlan, query)
        return "[]" if work_plans.nil?
        result = work_plans.as(Array).join(",") do |w|
          info = w.year.to_s + "\n" + w.plan.to_s
          "[" + w.faculty_id.to_s + "," + info.to_json + "]"
        end
        "[" + result + "]"
      end
    end
  end
end
