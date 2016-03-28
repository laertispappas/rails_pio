class Country
  include Mongoid::Document
  field :two_digit_code, type: String

  has_many :users, dependent: :destroy
  has_many :cities, dependent: :destroy
end
