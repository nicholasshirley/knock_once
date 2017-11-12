module KnockOnce
  class User < ApplicationRecord
    # these allow passing non-DB params for different situations
    attr_accessor :current_password
    attr_accessor :token

    has_secure_password

    before_save { email.downcase! }

    valid_email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

    validates :user_name,
      presence: true,
      length: { maximum: 25},
      uniqueness: { case_sensitive: false }
    validates :email,
      presence: true,
      length: { maximum: 255 },
      format: { with: valid_email_regex },
      uniqueness: { case_sensitive: false }
    validates :password_digest,
      presence: true
    validates :password,
      presence: true,
      length: { minimum: 8 },
      allow_nil: true



    # Send additional user info as payload for front end
    def to_token_payload
      {
        sub: id,
        email: email
      }
    end
  end
end
