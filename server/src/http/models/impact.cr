module MyServer
  module HttpAPI
    class Impact < Crecto::Model
      schema "impacts" do
        field :impact_indicator, String
        field :number_field, Int64
      end

      def to_json
        result = String.build do |str|
          str << "{"
          str << "\"id\":" << @id << ","
          str << "\"impactIndicator\":" << @impact_indicator.to_json << ","
          str << "\"numberField\":" << @number_field.to_json
          str << "}"
        end
        result
      end

      def self.get_impacts
        items = Repo.all(Impact)
        return items.as(Array) unless items.nil?
        [] of Impact
      end

      def self.get_impact(id)
        Repo.get(Impact, id)
      end

      def self.create_impact(impact)
        changeset = Repo.insert(impact)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.update_impact(impact)
        changeset = Repo.update(impact)
        raise changeset.errors.to_s unless changeset.valid?
      end

      def self.delete_impact(impact_id)
        impact = Repo.get!(Impact, impact_id)
        changeset = Repo.delete(impact)
        raise changeset.errors.to_s unless changeset.valid?
      end
    end
  end
end
