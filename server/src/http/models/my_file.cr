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
          str << "\"url\":" << @url.to_json
          str << "}"
        end
        result
      end

      def self.get_files
        items = Repo.all(MyFile)
        return items.as(Array) unless items.nil?
        [] of MyFile
      end

      def self.get_file(id)
        Repo.get(MyFile, id)
      end

      def self.create_file(file)
        changeset = Repo.insert(file)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.create_file_by_upload(file, file_type)
        raise "No static dir setup" unless ENV.has_key?("DWFI_WISE_STATIC")
        data_dir = File.join(ENV["DWFI_WISE_STATIC"], "dwfi_wise_files")

        filename = file.filename
        raise "No filename included in upload" unless filename.is_a?(String)

        ext = File.extname(filename)
        name = filename[0, (filename.size - ext.size)]
        new_name = filename
        i = 0
        while File.exists?(File.join(data_dir, new_name))
          i = i + 1
          new_name = name + "_" + i.to_s + ext
        end

        target_path = File.join(data_dir, new_name)
        File.open(target_path, "w") do |f|
          IO.copy(file.tmpfile, f)
        end

        f = MyFile.new
        f.name = new_name
        f.file_type = file_type
        f.url = "/dwfi_wise_files/" + new_name
        MyFile.create_file(f)
      end

      def self.update_file(file)
        changeset = Repo.update(file)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.delete_file(file_id)
        FileRelation.delete_file_relations(file_id)

        file = Repo.get!(MyFile, file_id)
        changeset = Repo.delete(file)
        raise changeset.errors.to_s unless changeset.valid?

        if (file.url.to_s.starts_with?("/"))
          raise "No static dir setup" unless ENV.has_key?("DWFI_WISE_STATIC")
          full_path = File.join(ENV["DWFI_WISE_STATIC"], file.url.to_s)
          if File.exists?(full_path)
            File.delete(full_path)
          end
        end
      end
    end

    class FileRelation < Crecto::Model
      schema "file_relations" do
        field :file_id, Int64
        field :for_table, String
        field :for_id, Int64
        field :comment, String
      end

      def to_json
        String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"fileId\":" << @file_id << ","
          str << "\"forTable\":" << @for_table.to_json << ","
          str << "\"forId\":" << @for_id << ","
          str << "\"comment\":" << @comment.to_json
          str << "}"
        end
      end

      def self.create_relations(relations, for_table, for_id)
        relations.each do |r|
          r.for_table = for_table
          r.for_id = for_id
          changeset = Repo.insert(r)
          raise changeset.errors.to_s unless changeset.valid?
        end
      end

      def self.get_relations(for_table, for_id)
        query = Crecto::Repo::Query.new
        query.where(for_table: for_table).where(for_id: for_id)
        relations = Repo.all(FileRelation, query)
        return [] of FileRelation if relations.nil?
        relations.as(Array)
      end

      def self.update_relations(relations, for_table, for_id)
        relations.each do |r|
          r.for_table = for_table
          r.for_id = for_id
          if (r.id)
            if (r.file_id.nil?)
              changeset = Repo.delete(r)
              raise changeset.errors.to_s unless changeset.valid?
            else
              changeset = Repo.update(r)
              raise changeset.errors.to_s unless changeset.valid?
            end
          else
            changeset = Repo.insert(r)
            raise changeset.errors.to_s unless changeset.valid?
          end
        end
      end

      def self.delete_relations(for_table, for_id)
        query = Crecto::Repo::Query.new
        query.where(for_table: for_table).where(for_id: for_id)
        Repo.delete_all(FileRelation, query)
      end

      def self.delete_file_relations(file_id)
        query = Crecto::Repo::Query.new
        query.where(file_id: file_id)
        Repo.delete_all(FileRelation, query)
      end
    end
  end
end
