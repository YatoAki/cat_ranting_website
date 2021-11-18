class CatRentalRequest < ActiveRecord::Base
    RENTAL_STATUS = %w(PENDING APPROVED DENIED)
    validates :cat_id,:start_date,:end_date,:status,presence: true
    validates :status, inclusion: RENTAL_STATUS

    belongs_to :cat
end