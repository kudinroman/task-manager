class Category < ApplicationRecord
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :subcategories, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy
  has_many :tasks, dependent: :destroy

  before_validation :set_depth

  validates :name, presence: true
  validate :depth_within_limit

  MAX_DEPTH = 5 # Set your desired maximum depth here

  private

  def set_depth
    self.depth = parent ? parent.depth + 1 : 0
  end

  def depth_within_limit
    errors.add(:base, "Maximum depth of #{MAX_DEPTH} levels exceeded") if depth >= MAX_DEPTH
  end
end
