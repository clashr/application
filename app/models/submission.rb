class Submission < ApplicationRecord
  belongs_to :contest
  validates :submitter, :BinUri, presence: true
end
