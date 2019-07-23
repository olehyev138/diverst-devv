class BaseClass < ActiveRecord::Base
  self.abstract_class = true

  include ::BaseSearch
  include ::BaseElasticsearch
  include ::BaseGraph

  def self.inherited(child)
    super
    child.instance_eval do
      include Elasticsearch::Model

      index_name "#{table_name}"
      document_type "#{table_name.singularize}"
    end
  end

  def self.left_joins(*field)
    join_command = field_to_left_join_sql(*field)
    self.joins(join_command)
  end

  def self.get_association_table_name(association)
    self.reflections[association.to_s].klass.table_name
  end

  after_commit on: [:create] { update_elasticsearch_index('index') }
  after_commit on: [:update] { update_elasticsearch_index('update') }
  after_commit on: [:destroy] { update_elasticsearch_index('delete') }

  private

  def self.field_to_left_join_sql(*fields)
    joined = []
    fields.reduce('') do |full_join, field|
      reflection = self.reflections[field.to_s]
      raise "#{field} is not a field of #{self.class}" unless reflection.present?

      chain = reflection.chain.reverse
      table_name = self.table_name
      full_join + chain.reduce(['', table_name]) do |sum, n|
        if joined.include?([n.klass, n.foreign_key])
          sum
        else
          joined.append([n.klass, n.foreign_key])
          [
            n.source_macro == :belongs_to ?
              sum[0] + " LEFT JOIN `#{n.klass.table_name}` ON `#{n.klass.table_name}`.`id` = `#{sum[1]}`.`#{n.foreign_key}`" :
              sum[0] + " LEFT JOIN `#{n.klass.table_name}` ON `#{sum[1]}`.`id` = `#{n.klass.table_name}`.`#{n.foreign_key}`",
            n.klass.table_name
          ]
        end
      end[0]
    end
  end
end

def map(a, b)
  while a.present? do
    b.append({ name: a.name, table: a.klass.table_name, foreign: a.foreign_key, macro: a.macro, source_macro: a.source_macro })
    a = a.through_reflection
  end
  b
end
