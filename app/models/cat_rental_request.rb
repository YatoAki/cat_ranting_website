class CatRentalRequest < ActiveRecord::Base
    RENTAL_STATUS = %w(PENDING APPROVED DENIED)
    validates :cat_id,:start_date,:end_date,:status,presence: true
    validates :status, inclusion: RENTAL_STATUS
    validate :does_not_overlap_approved_request

    belongs_to :cat

    def approve!
        raise "The request is not pending" unless self.status == 'PENDING'
        transaction do
            self.status = 'APPROVED'
            self.save!
            overlapping_pending_requests.each do |req|
                req.update!(status: 'DENIED')
            end
        end
    end

    def pending?
        self.status == 'PENDING'
    end

    def deny!
        self.status = 'DENIED'
        self.save!
    end

    def overlapping_requests
        CatRentalRequest
        .where.not(id: self.id)
        .where(cat_id: self.cat_id)
        .where.not('start_date > :end_date OR end_date < :start_date',start_date: start_date,end_date: end_date)
    end

    def overlapping_approved_requests
        overlapping_requests.where('status = \'APROVED\'')
    end

    def overlapping_pending_requests
        overlapping_requests.where('status = \'PENDING\'')
    end

    def does_not_overlap_approved_request
        unless overlapping_approved_requests.empty?
            errors[:base] <<
                "Request conflict with other exciting approved request"
        end
    end
end