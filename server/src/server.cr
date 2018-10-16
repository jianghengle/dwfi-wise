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

      get "/get_projects" do |env|
        HttpAPI::ProjectController.get_projects(env)
      end

      get "/get_events" do |env|
        HttpAPI::EventController.get_events(env)
      end

      get "/get_visiting_scholars" do |env|
        HttpAPI::VisitingScholarController.get_visiting_scholars(env)
      end

      get "/get_people" do |env|
        HttpAPI::PeopleController.get_people(env)
      end

      get "/get_publications" do |env|
        HttpAPI::PublicationController.get_publications(env)
      end

      get "/get_files" do |env|
        HttpAPI::FileController.get_files(env)
      end

      Kemal.run
    end
  end
end

MyServer::Server.new
