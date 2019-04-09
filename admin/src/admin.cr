require "pg"
require "crecto-admin"

module Repo
  extend Crecto::Repo
  config do |conf|
    conf.adapter = Crecto::Adapters::Postgres
    conf.uri = ENV["DB_URL"]
  end
end

class User < Crecto::Model
  schema "users" do
    field :email, String
    field :encrypted_password, String
    field :auth_token, String
    field :privileges, String
  end

  def self.collection_attributes
    return [:email, :privileges, :created_at, :updated_at]
  end

  def self.form_attributes
    [{:email, "string"},
     {:encrypted_password, "password"},
     {:auth_token, "string"},
     {:privileges, "enum", ["Read Only", "Edit", "Approve", "None"]}]
  end

  def self.can_access(user)
    return false unless user.is_a? User
    user.privileges.to_s == "Approve"
  end
end

class MyFile < Crecto::Model
  schema "files" do
    field :name, String
    field :file_type, String
    field :url, String
  end

  def self.can_access(user)
    return false unless user.is_a? User
    user.email.to_s == "jianghengle@gmail.com"
  end
end

class FileRelation < Crecto::Model
  schema "file_relations" do
    field :file_id, Int64
    field :for_table, String
    field :for_id, Int64
    field :comment, String
  end

  def self.can_access(user)
    return false unless user.is_a? User
    user.email.to_s == "jianghengle@gmail.com"
  end
end

class Grant < Crecto::Model
  schema "grants" do
    field :organization, String
    field :comment, String
  end

  def self.can_access(user)
    return false unless user.is_a? User
    user.email.to_s == "jianghengle@gmail.com"
  end
end

class GrantRelation < Crecto::Model
  schema "grant_relations" do
    field :grant_id, Int64
    field :for_table, String
    field :for_id, Int64
    field :comment, String
  end

  def self.can_access(user)
    return false unless user.is_a? User
    user.email.to_s == "jianghengle@gmail.com"
  end
end

class People < Crecto::Model
  schema "people" do
    field :first_name, String
    field :last_name, String
    field :credentials, String
    field :title, String
    field :employer, String
    field :dwfi_affiliation, String
    field :email, String
    field :phone, String
    field :website, String
  end

  def self.can_access(user)
    return false unless user.is_a? User
    user.email.to_s == "jianghengle@gmail.com"
  end
end

class PeopleRelation < Crecto::Model
  schema "people_relations" do
    field :people_id, Int64
    field :for_table, String
    field :for_id, Int64
    field :role, String
  end

  def self.can_access(user)
    return false unless user.is_a? User
    user.email.to_s == "jianghengle@gmail.com"
  end
end

class Publication < Crecto::Model
  schema "publications" do
    field :title, String
    field :authors, String
    field :abstract, String
    field :focus_area, String
    field :url, String
    field :status, String
    field :point_of_contact, Int64
    field :country, String
  end

  def self.can_access(user)
    return false unless user.is_a? User
    user.email.to_s == "jianghengle@gmail.com"
  end
end

class PublicationRelation < Crecto::Model
  schema "publication_relations" do
    field :publication_id, Int64
    field :for_table, String
    field :for_id, Int64
    field :comment, String
  end

  def self.can_access(user)
    return false unless user.is_a? User
    user.email.to_s == "jianghengle@gmail.com"
  end
end

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

  def self.can_access(user)
    return false unless user.is_a? User
    user.email.to_s == "jianghengle@gmail.com"
  end
end

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

  def self.can_access(user)
    return false unless user.is_a? User
    user.email.to_s == "jianghengle@gmail.com"
  end
end

class MyEvent < Crecto::Model
  schema "events" do
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
  end

  def self.can_access(user)
    return false unless user.is_a? User
    user.email.to_s == "jianghengle@gmail.com"
  end
end

class VisitingScholar < Crecto::Model
  schema "visiting_scholars" do
    field :first_name, String
    field :last_name, String
    field :country, String
    field :state, String
    field :research_topic, String
    field :description, String
    field :status, String
    field :focus_area, String
    field :program_id, Int64
    field :start_date, Time
    field :end_date, Time
    field :funding, String
    field :collaborators, String
    field :more_information, String
    field :point_of_contact, Int64
    field :is_published, Bool
  end

  def self.can_access(user)
    return false unless user.is_a? User
    user.email.to_s == "jianghengle@gmail.com"
  end
end

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

  def self.form_attributes
    [:people_id,
     :year_joined,
     {:status, "enum", ["New", "Returning"]},
     {:campus, "enum", ["UNL", "UNO", "UNK", "UNMC", "Other"]},
     {:department, "string"},
     {:area_of_expertise, "text"},
     {:expertise_title, "string"}]
  end

  def self.can_access(user)
    return false unless user.is_a? User
    user.email.to_s == "jianghengle@gmail.com"
  end
end

class WorkPlan < Crecto::Model
  schema "work_plans" do
    field :faculty_id, Int64
    field :year, Int64
    field :plan, String
  end

  def self.can_access(user)
    return false unless user.is_a? User
    user.email.to_s == "jianghengle@gmail.com"
  end
end

CrectoAdmin.config do |config|
  config.auth_enabled = true
  config.auth = CrectoAdmin::DatabaseAuth
  config.auth_repo = Repo
  config.auth_model = User
  config.auth_model_identifier = :email
  config.auth_model_password = :encrypted_password
  config.app_name = "UNDA Admin"
end

init_admin()

admin_resource(User, Repo)
admin_resource(MyFile, Repo)
admin_resource(FileRelation, Repo)
admin_resource(Grant, Repo)
admin_resource(GrantRelation, Repo)
admin_resource(People, Repo)
admin_resource(PeopleRelation, Repo)
admin_resource(Publication, Repo)
admin_resource(PublicationRelation, Repo)
admin_resource(Program, Repo)
admin_resource(Project, Repo)
admin_resource(MyEvent, Repo)
admin_resource(VisitingScholar, Repo)
admin_resource(Faculty, Repo)
admin_resource(WorkPlan, Repo)

Kemal::Session.config do |config|
  config.secret = "sTHxjX3R"
  config.secret = ENV["ADMIN_SECRET"] if ENV.has_key?("ADMIN_SECRET")
end

Kemal.run 4001
