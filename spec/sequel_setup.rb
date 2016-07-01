DB = Sequel.sqlite
Sequel::Model.plugin :schema
Sequel::Model.plugin :polymorphic

class Asset < Sequel::Model
  set_schema do
    primary_key :id
    String  :name
    Integer :attachable_id
    String  :attachable_type
  end

  many_to_one :attachable, :polymorphic => true
end


class Tagging < Sequel::Model
  set_schema do
    Integer :taggable_id
    String  :taggable_type
    Integer :tag_id
  end

  many_to_one :taggable, :polymorphic => true
  many_to_one :tag
end


class Post < Sequel::Model
  set_schema do
    primary_key :id
    String :name
    Integer :postable_id
    String :postable_type
  end

  one_to_many :assets, :as => :attachable
  many_to_many :tags, :through => :taggings, :as => :taggable

  many_to_one :postable, polymorphic: true

  one_to_one :picture, class: '::Media', as: :mediable
end


class Note < Sequel::Model
  set_schema do
    primary_key :id
    String :name
  end

  one_to_many :assets, :as => :attachable
end


class Tag < Sequel::Model
  set_schema do
    primary_key :id
    String :name
  end
end

class Question < Sequel::Model
  set_schema do
    primary_key :id
  end

  one_to_one :post, as: :postable
end

class Media < Sequel::Model
  set_schema do
    primary_key :id
    String :mediable_type
    Integer :mediable_id
  end

  many_to_one :mediable, polymorphic: true
end

[Asset, Post, Note, Tag, Tagging, Question, Media].each {|klass| klass.create_table!}
