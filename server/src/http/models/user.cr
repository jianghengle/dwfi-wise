module MyServer
  module HttpAPI
    class User < Crecto::Model
      schema "users" do
        field :email, String
        field :encrypted_password, String
        field :auth_token, String
        field :privileges, String
      end

      def to_json
        String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"email\":" << @email.to_json << ","
          str << "\"privileges\":" << @privileges.to_json << ","
          str << "\"createdTime\":" << @created_at.as(Time).to_unix
          str << "}"
        end
      end

      def self.get_user(email : String, password : String)
        user = Repo.get_by(User, email: email)
        raise "Cannot find user" if user.nil?
        raise "Cannot verify password" unless Crypto::Bcrypt::Password.new(user.encrypted_password.not_nil!) == password
        user
      end

      def self.get_user_by_token(token : String)
        user = Repo.get_by(User, auth_token: token)
        raise "Cannot find user" if user.nil?
        user
      end

      def self.create_user(email, password)
        user = Repo.get_by(User, email: email)
        raise "User existed!" unless user.nil?

        new_user = User.new
        new_user.email = email
        encrypted_password = Crypto::Bcrypt::Password.create(password)
        raise "failed to encrypted password" if encrypted_password.nil?
        new_user.encrypted_password = encrypted_password.to_s

        new_user.auth_token = Random::Secure.base64(32).to_s
        new_user.privileges = "None"
        changeset = Repo.insert(new_user)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.change_password(user, password)
        encrypted_password = Crypto::Bcrypt::Password.create(password)
        raise "failed to encrypted password" if encrypted_password.nil?
        user.encrypted_password = encrypted_password.to_s
        changeset = Repo.update(user)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.get_users
        items = Repo.all(User)
        return items.as(Array) unless items.nil?
        [] of User
      end

      def self.update_user(id, privileges)
        user = Repo.get!(User, id)
        user.privileges = privileges
        changeset = Repo.update(user)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.delete_user(id)
        user = Repo.get!(User, id)
        changeset = Repo.delete(user)
        raise changeset.errors.to_s unless changeset.valid?
      end
    end
  end
end
