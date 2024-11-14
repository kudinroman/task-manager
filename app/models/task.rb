class Task < ApplicationRecord
  belongs_to :category

  validates :name, :description, :status, presence: true
end
