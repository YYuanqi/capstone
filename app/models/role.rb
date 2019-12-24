class Role < ActiveRecord::Base
  ADMIN = 'admin'
  ORIGINATOR = 'originator'
  ORGANIZER = 'orgnizer'
  MEMBER='member'

  belongs_to :user, inverse_of: roles

  scope :relevant, lambda do |model_name, model_id|
    where('mname is null or (mname=:mname and (mid is null or mid=:mid))',
          mnane: model_name, mid: model_id)
  end
end
