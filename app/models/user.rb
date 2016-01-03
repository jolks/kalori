class User < ActiveRecord::Base
  before_save :downcase_email
  has_secure_password
  has_many :calories

  validate do
    errors.add(:email, "email is not unique") if email_not_unique
    errors.add(:username, "username is not unique") if username_not_unique
  end

  def email_not_unique
    User.where(:email => self.email).first.present?
  end

  def username_not_unique
    User.where(:username => self.username).first.present?
  end

  private
    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end
end
