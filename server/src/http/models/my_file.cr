module MyServer
  module HttpAPI
    class MyFile < Crecto::Model
      schema "files" do
        field :name, String
        field :file_type, String
        field :url, String
      end

      def to_json
        result = String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"name\":" << @name.to_json << ","
          str << "\"fileType\":" << @file_type.to_json << ","
          str << "\"url\":" << @url.to_json << ","
          str << "\"createdAt\":" << @created_at.as(Time).epoch << ","
          str << "\"updatedAt\":" << @updated_at.as(Time).epoch
          str << "}"
        end
        result
      end

      def self.get_files
        items = Repo.all(MyFile)
        return items.as(Array) unless items.nil?
        [] of MyFile
      end
    end
  end
end
