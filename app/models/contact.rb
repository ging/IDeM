class Contact < ActiveRecord::Base
  validates :sender_id, uniqueness: { scope: :receiver_id }, :presence => true
  validates_presence_of :receiver_id

  def inverse
    Contact.where(sender_id: self.receiver_id, receiver_id: self.sender_id).first
  end

  def reflective?
    !self.inverse.blank?
  end
end