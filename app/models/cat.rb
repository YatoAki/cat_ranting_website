class Cat < ActiveRecord::Base
    CAT_COLORS = %w(black white orange gray)
    validates :birth_date, :color, :name, :sex, :description, presence: true
    validates :color, inclusion: CAT_COLORS
    validates :sex, inclusion: %w(M F)
end