module Sources
  class PolymorphicLoader < GraphQL::Dataloader::Source
    def initialize(association_name)
      @association_name = association_name
    end

    def fetch(records)
      # Group by polymorphic type, then batch-load each group
      grouped = records.group_by { |r| r.public_send("#{@association_name}_type") }

      loaded = {}
      grouped.each do |type_name, group_records|
        klass = type_name.constantize
        ids = group_records.map { |r| r.public_send("#{@association_name}_id") }
        by_id = klass.where(id: ids).index_by(&:id)
        group_records.each do |r|
          loaded[r] = by_id[r.public_send("#{@association_name}_id")]
        end
      end

      records.map { |r| loaded[r] }
    end
  end
end
