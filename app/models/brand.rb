class Brand
  include Mongoid::Document
  field :name, type: String
  has_many :users
end
