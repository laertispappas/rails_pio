class User
  include Mongoid::Document
  include AgnosticBackend::Indexable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
  field :gender, type: String 
  field :customer_type, type: String
  belongs_to :country
  belongs_to :brand
  has_many :trips, dependent: :destroy

  index({ email: 1 }, { unique: true, name: 'user_email_index' })

  define_index_fields(owner: Trip) do
    string :id, value: proc { id.to_s }
    string :email
    string :gender
    string :country, value: proc { country.two_digit_code }
    string :brand, value: proc { brand.name }
  end

  define_index_notifier(target: Trip) { trips }
end
