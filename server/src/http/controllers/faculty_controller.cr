require "./controller_base"

module MyServer
  module HttpAPI
    module FacultyController
      include MyServer::HttpAPI::ControllerBase
      extend self

      def get_faculty(ctx)
        begin
          items = Faculty.get_all_faculty
          return "[]" if items.empty?

          people_ids = items.map { |f| f.people_id }
          people_map = People.get_people_map(people_ids)
          "[" + (items.join(", ") { |i| i.to_json(people_map[i.people_id.to_s]) }) + "]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def get_one_faculty(ctx)
        begin
          user = verify_token(ctx)
          id = get_param!(ctx, "id").to_i
          faculty = Faculty.get_one_faculty(id)
          raise "cannot find faculty" if faculty.nil?
          people_map = People.get_people_map([faculty.people_id])
          people = people_map[faculty.people_id.to_s]
          work_plans = WorkPlan.get_work_plans(id)
          work_plans_json = "[" + work_plans.join(", ") { |w| w.to_json } + "]"
          "[ #{faculty.to_json(people)}, #{work_plans_json}]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def create_faculty(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          faculty = Faculty.new
          faculty.people_id = get_param!(ctx, "peopleId")
          faculty.year_joined = get_param!(ctx, "yearJoined")
          faculty.status = get_param!(ctx, "status")
          faculty.campus = get_param!(ctx, "campus")
          faculty.department = get_param!(ctx, "department")
          faculty.area_of_expertise = get_param!(ctx, "areaOfExpertise")
          faculty.expertise_title = get_param!(ctx, "expertiseTitle")

          work_plans = Array(WorkPlan).from_json(get_param!(ctx, "workPlans"))

          Faculty.create_faculty(faculty, work_plans)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def update_faculty(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          faculty = Faculty.new
          faculty.id = get_param!(ctx, "id").to_i
          faculty.people_id = get_param!(ctx, "peopleId")
          faculty.year_joined = get_param!(ctx, "yearJoined")
          faculty.status = get_param!(ctx, "status")
          faculty.campus = get_param!(ctx, "campus")
          faculty.department = get_param!(ctx, "department")
          faculty.area_of_expertise = get_param!(ctx, "areaOfExpertise")
          faculty.expertise_title = get_param!(ctx, "expertiseTitle")

          work_plans = Array(WorkPlan).from_json(get_param!(ctx, "workPlans"))

          Faculty.update_faculty(faculty, work_plans)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def delete_faculty(ctx)
        begin
          user = verify_token(ctx)
          raise "Permission denied" unless (user.privileges.to_s == "Edit" || user.privileges.to_s == "Approve")

          faculty_id = get_param!(ctx, "facultyId").to_i
          Faculty.delete_faculty(faculty_id)
          {ok: true}.to_json
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end

      def export_work_plans(ctx)
        begin
          user = verify_token(ctx)
          ids = Array(Int64).from_json(get_param!(ctx, "ids"))
          WorkPlan.export_work_plans(ids)
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end
    end
  end
end
