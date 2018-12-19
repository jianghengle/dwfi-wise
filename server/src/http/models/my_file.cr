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

      def self.get_file_map(ids)
        map = Hash(String, MyFile).new
        query = Query.where(:id, ids)
        items = Repo.all(MyFile, query)
        return map if items.nil?
        items.as(Array).each do |i|
          map[i.id.to_s] = i
        end
        map
      end

      def self.create_file(env)
        upload_file = "Yes"
        file = MyFile.new
        HTTP::FormData.parse(env.request) do |part|
          if part.name == "uploadFile"
            upload_file = part.body.gets_to_end
          elsif part.name == "name"
            file.name = part.body.gets_to_end
          elsif part.name == "fileType"
            file.file_type = part.body.gets_to_end
          elsif part.name == "url"
            file.url = part.body.gets_to_end
          elsif part.name == "file"
            if upload_file == "Yes"
              raise "No static dir setup" unless ENV.has_key?("DWFI_WISE_STATIC")
              data_dir = File.join(ENV["DWFI_WISE_STATIC"], "dwfi_wise_files")

              filename = part.filename
              raise "No filename included in upload" unless filename.is_a?(String)

              unique_name = MyFile.get_unique_filename(data_dir, filename)
              target_path = File.join(data_dir, unique_name)
              File.open(target_path, "w") do |f|
                IO.copy(part.body, f)
              end

              file.name = unique_name
              file.url = "/dwfi_wise_files/" + unique_name
            end
          end
        end

        changeset = Repo.insert(file)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.get_unique_filename(path, filename)
        ext = File.extname(filename)
        name = filename[0, (filename.size - ext.size)]
        new_name = filename
        i = 0
        while File.exists?(File.join(path, new_name))
          i = i + 1
          new_name = name + "_" + i.to_s + ext
        end
        new_name
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

      def self.export_files(table_name, ids)
        query = Query.where(for_table: table_name).where(:for_id, ids)
        relations = Repo.all(FileRelation, query)
        return "[]" if relations.nil?
        relations = relations.as(Array)
        file_ids = relations.map { |r| r.file_id }
        file_map = MyFile.get_file_map(file_ids)
        result = relations.join(",") do |r|
          file_id = r.file_id.to_s
          info = file_id + ", " + r.comment.to_s + ", " + file_map[file_id].name.to_s
          "[" + r.for_id.to_s + "," + info.to_json + "]"
        end
        "[" + result + "]"
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
