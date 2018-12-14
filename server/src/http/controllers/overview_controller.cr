require "./controller_base"

module MyServer
  module HttpAPI
    module OverviewController
      include MyServer::HttpAPI::ControllerBase
      extend self

      def get_overview(ctx)
        begin
          programs = Program.get_published_programs
          programCountries = [] of String
          programs.each do |p|
            next if p.country.nil?
            p.country.to_s.split(",") { |s| programCountries << s.strip unless s.strip.empty? }
          end

          projects = Project.get_published_projects
          projectCountries = [] of String
          projects.each do |p|
            next if p.country.nil?
            p.country.to_s.split(",") { |s| projectCountries << s.strip unless s.strip.empty? }
          end

          events = MyEvent.get_published_events
          eventCountries = [] of String
          events.each do |e|
            next if e.country.nil?
            eventCountries << e.country.to_s unless e.country.to_s.empty?
          end

          scholars = VisitingScholar.get_published_visiting_scholars
          scholarCountries = [] of String
          scholars.each do |s|
            next if s.country.nil?
            scholarCountries << s.country.to_s unless s.country.to_s.empty?
          end

          grantors = Grant.get_grants

          faculty = Faculty.get_all_faculty

          countries = programCountries | projectCountries | eventCountries | scholarCountries

          json_str = ["[" + (countries.join(", ") { |c| c.to_json }) + "]", programs.size.to_s, projects.size.to_s, events.size.to_s, scholars.size.to_s, grantors.size.to_s, faculty.size.to_s]
          "[" + json_str.join(", ") + "]"
        rescue ex : InsufficientParameters
          error(ctx, "Not all required parameters were present")
        rescue e : Exception
          error(ctx, e.message.to_s)
        end
      end
    end
  end
end
