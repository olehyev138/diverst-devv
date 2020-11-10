class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include BaseBuilder
  include BasePager
  include BaseSearcher
  include BaseSearch
  include BaseElasticsearch
  include BaseGraph
  include BaseCsvExport
  include ActionView::Helpers::DateHelper

  scope :except_id, -> (id) { where.not(id: id.presence) }

  def time_since_creation
    time_ago_in_words created_at
  end

  def to_label
    if respond_to?('name')
      name
    elsif respond_to?('title')
      title
    elsif respond_to?('subject')
      subject
    elsif respond_to?('description')
      description
    else
      "#{self.class.name}(#{id})"
    end
  end

  def self.column_reload!
    self.connection.schema_cache.clear!
    self.reset_column_information
  end

  # Defines alias to access polymorphic data as if it weren't
  #
  # For example
  # class GroupLeader
  #   belongs_to :leader_of, polymorphic: true
  #   polymorphic_alias :leader_of, Group
  #   polymorphic_alias :leader_of, Region
  # end
  #
  # gl = GroupLeader.first
  #
  # gl.group // if leader_of is a group, return it
  # gl.group = Group.first // sets leader_ofK
  # gl.group = Region.first // ArgumentError "Must pass a Group"
  #
  # gl.group_id // if leader_of is a group, return leader_of_id
  # gl.group_id = 1 // sets leader_of_id to 1 and leader_of_type to 'Group'
  def self.polymorphic_alias(field, model)
    define_method model.model_name.singular do
      if model.model_name.name == send("#{field}_type")
        send(field)
      end
    end
    define_method "#{model.model_name.singular}=" do |arg|
      raise ArgumentError, "Must pass a #{model.model_name.name}" unless arg.is_a? model

      send("#{field}=", arg)
    end
    define_method "#{model.model_name.singular}_id=" do |id|
      send("#{field}_id=", id)
      send("#{field}_type=", model.model_name.name)
    end
    define_method "#{model.model_name.singular}_id" do
      send("#{field}_id") if model.model_name.name == send("#{field}_type")
    end
  end

  ActiveRecord::Associations::Association.class_eval do
    def target_scope
      ActiveRecord::AssociationRelation.create(klass, self).merge!(klass.scope_for_association)
    end
  end

  def self.inherited(child)
    super

    child.instance_eval do
      # Elastic search functionality!
      include Elasticsearch::Model

      index_name "#{table_name}"
      document_type "#{table_name.singularize}"
    end
  end

  def self.get_association(name)
    reflect_on_all_associations.find { |ass| ass.name == name.to_sym }
  end

  after_commit on: [:create] do update_elasticsearch_index('index') end
  after_commit on: [:update] do update_elasticsearch_index('update') end
  after_commit on: [:destroy] do update_elasticsearch_index('delete') end

  def self.custom_or(right_raw, joins_to_left: true)
    left = all
    right = right_raw.all

    raise ::ArgumentError.new('Can only `or` between two queries of the same Klass') unless left.klass == right.klass

    merged = left.merge(right)

    l_where_clause = left.where_clause
    r_where_clause = right.where_clause
    or_clause = l_where_clause.or(r_where_clause)
    merged.where_clause = or_clause

    if joins_to_left
      l_joins = left.joins_values
      r_joins = right.joins_values

      def self.inner_to_left(joins, query)
        left_joins = []
        inner_joins = []
        joins.each do |j|
          case j
          when Arel::Nodes::Join
            inner_joins.append Arel::Nodes::OuterJoin.new(j.left, j.right)
          when String then raise ::ArgumentError.new("Can't `or` when joins are defined by strings")
          else left_joins.append j
          end
        end
        return left_joins, inner_joins
      end

      l_new_left, l_new_inner = inner_to_left(l_joins, left)
      r_new_left, r_new_inner = inner_to_left(r_joins, right)

      merged.left_outer_joins_values |= l_new_left | r_new_left
      merged.joins_values = l_new_inner | r_new_inner
    end

    merged
  end

  def self.summ(column)
    query = all
    if query.distinct_value
      query.klass
          .unscoped
          .select("SUM(#{column}) as total_sum")
          .from(query.select("#{table_name}.id, #{table_name}.#{column}"))[0]
          .total_sum
    else
      query.sum(column)
    end
  end

  def self.sum_and_count(column)
    query = all
    if query.distinct_value
      query = query.klass
                  .unscoped
                  .select("SUM(#{column}) as total_sum, COUNT(id) as total_count")
                  .from(query.select("#{table_name}.id, #{table_name}.#{column}"))[0]
    else
      query = query.select("SUM(#{table_name}.#{column}) as total_sum, COUNT(#{table_name}.id) as total_count")[0]
    end
    [query.total_sum, query.total_count]
  end

  if Rails.env.development?
    def self.preload_test(preload: true, limit: 10, serializer: nil)
      arr = []
      if self.respond_to?(:base_preloads) && preload
        items = self.preload_all
        items = items.limit(limit)
        items.load
        p 'Preloaded'
      else
        items = self.limit(limit)
      end
      items.each do |item|
        p "Serializing object with id = #{item.id}"
        arr << (serializer || ActiveModel::Serializer.serializer_for(item)).new(item).as_json
      end
      nil
    end
  end

  def self.preload_all
    preload(base_preloads || [])
  end

  protected

  def self.sql_where(*args)
    sql = self.unscoped.where(*args).to_sql
    match = sql.match(/WHERE\s(.*)$/)
    "(#{match[1]})"
  end
end
