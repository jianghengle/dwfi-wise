require "pg"
require "crecto"
require "kemal"
require "json"
require "crypto/bcrypt/password"

require "./http/models/*"
require "./http/errors/*"
require "./http/controllers/*"
require "./http/middleware/*"

module Repo
  extend Crecto::Repo

  config do |conf|
    conf.adapter = Crecto::Adapters::Postgres
    conf.uri = ENV["DB_URL"]
  end
end

Query = Crecto::Repo::Query

module MyServer
  class Server
    def initialize
      # Middlewares
      add_handler MyServer::HttpAPI::ApiHandler.new

      get "/" do |env|
        env.redirect "/index.html"
      end

      get "/get_overview" do |env|
        HttpAPI::OverviewController.get_overview(env)
      end

      post "/get_auth_token" do |env|
        HttpAPI::UserController.get_auth_token(env)
      end

      get "/get_programs" do |env|
        HttpAPI::ProgramController.get_programs(env)
      end

      get "/get_program/:id" do |env|
        HttpAPI::ProgramController.get_program(env)
      end

      post "/create_program" do |env|
        HttpAPI::ProgramController.create_program(env)
      end

      post "/update_program/:id" do |env|
        HttpAPI::ProgramController.update_program(env)
      end

      post "/delete_program" do |env|
        HttpAPI::ProgramController.delete_program(env)
      end

      get "/count_programs_for_map" do |env|
        HttpAPI::ProgramController.count_programs_for_map(env)
      end

      get "/get_programs_for_map/:country" do |env|
        HttpAPI::ProgramController.get_programs_for_map(env)
      end

      get "/get_projects" do |env|
        HttpAPI::ProjectController.get_projects(env)
      end

      get "/get_project/:id" do |env|
        HttpAPI::ProjectController.get_project(env)
      end

      post "/create_project" do |env|
        HttpAPI::ProjectController.create_project(env)
      end

      post "/update_project/:id" do |env|
        HttpAPI::ProjectController.update_project(env)
      end

      post "/delete_project" do |env|
        HttpAPI::ProjectController.delete_project(env)
      end

      get "/count_projects_for_map" do |env|
        HttpAPI::ProjectController.count_projects_for_map(env)
      end

      get "/get_projects_for_map/:country" do |env|
        HttpAPI::ProjectController.get_projects_for_map(env)
      end

      get "/get_events" do |env|
        HttpAPI::EventController.get_events(env)
      end

      get "/get_event/:id" do |env|
        HttpAPI::EventController.get_event(env)
      end

      post "/create_event" do |env|
        HttpAPI::EventController.create_event(env)
      end

      post "/update_event/:id" do |env|
        HttpAPI::EventController.update_event(env)
      end

      post "/delete_event" do |env|
        HttpAPI::EventController.delete_event(env)
      end

      get "/count_events_for_map" do |env|
        HttpAPI::EventController.count_events_for_map(env)
      end

      get "/get_events_for_map/:country" do |env|
        HttpAPI::EventController.get_events_for_map(env)
      end

      get "/get_visiting_scholars" do |env|
        HttpAPI::VisitingScholarController.get_visiting_scholars(env)
      end

      get "/get_visiting_scholar/:id" do |env|
        HttpAPI::VisitingScholarController.get_visiting_scholar(env)
      end

      post "/create_visiting_scholar" do |env|
        HttpAPI::VisitingScholarController.create_visiting_scholar(env)
      end

      post "/update_visiting_scholar/:id" do |env|
        HttpAPI::VisitingScholarController.update_visiting_scholar(env)
      end

      post "/delete_visiting_scholar" do |env|
        HttpAPI::VisitingScholarController.delete_visiting_scholar(env)
      end

      get "/count_visiting_scholars_for_map" do |env|
        HttpAPI::VisitingScholarController.count_visiting_scholars_for_map(env)
      end

      get "/get_visiting_scholars_for_map/:country" do |env|
        HttpAPI::VisitingScholarController.get_visiting_scholars_for_map(env)
      end

      get "/get_people" do |env|
        HttpAPI::PeopleController.get_people(env)
      end

      get "/get_one_people/:id" do |env|
        HttpAPI::PeopleController.get_one_people(env)
      end

      post "/create_people" do |env|
        HttpAPI::PeopleController.create_people(env)
      end

      post "/update_people/:id" do |env|
        HttpAPI::PeopleController.update_people(env)
      end

      post "/delete_people" do |env|
        HttpAPI::PeopleController.delete_people(env)
      end

      get "/get_publications" do |env|
        HttpAPI::PublicationController.get_publications(env)
      end

      get "/get_publication/:id" do |env|
        HttpAPI::PublicationController.get_publication(env)
      end

      post "/create_publication" do |env|
        HttpAPI::PublicationController.create_publication(env)
      end

      post "/update_publication/:id" do |env|
        HttpAPI::PublicationController.update_publication(env)
      end

      post "/delete_publication" do |env|
        HttpAPI::PublicationController.delete_publication(env)
      end

      get "/get_files" do |env|
        HttpAPI::FileController.get_files(env)
      end

      get "/get_file/:id" do |env|
        HttpAPI::FileController.get_file(env)
      end

      post "/create_file" do |env|
        HttpAPI::FileController.create_file(env)
      end

      post "/update_file/:id" do |env|
        HttpAPI::FileController.update_file(env)
      end

      post "/delete_file" do |env|
        HttpAPI::FileController.delete_file(env)
      end

      get "/get_grants" do |env|
        HttpAPI::GrantController.get_grants(env)
      end

      get "/get_grant/:id" do |env|
        HttpAPI::GrantController.get_grant(env)
      end

      post "/create_grant" do |env|
        HttpAPI::GrantController.create_grant(env)
      end

      post "/update_grant/:id" do |env|
        HttpAPI::GrantController.update_grant(env)
      end

      post "/delete_grant" do |env|
        HttpAPI::GrantController.delete_grant(env)
      end

      get "/get_faculty" do |env|
        HttpAPI::FacultyController.get_faculty(env)
      end

      get "/get_one_faculty/:id" do |env|
        HttpAPI::FacultyController.get_one_faculty(env)
      end

      post "/create_faculty" do |env|
        HttpAPI::FacultyController.create_faculty(env)
      end

      post "/update_faculty/:id" do |env|
        HttpAPI::FacultyController.update_faculty(env)
      end

      post "/delete_faculty" do |env|
        HttpAPI::FacultyController.delete_faculty(env)
      end

      serve_static({"gzip" => true, "dir_listing" => true})

      Kemal.run 4000
    end
  end
end

MyServer::Server.new
