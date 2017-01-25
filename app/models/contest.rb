class Contest < ApplicationRecord
	has_many :submissions
	validates :name, :description, :duedate, presence: true
end
