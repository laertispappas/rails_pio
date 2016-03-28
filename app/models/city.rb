class City
  include Mongoid::Document
  field :name, type: String

  belongs_to :country
  has_many :airports, dependent: :destroy
  #embedded_in :country
  #embeds_many :airports
  
  index({ name: "text" })

  def self.search(q)
    City.where(:name => /#{q}/i)
  end

end
