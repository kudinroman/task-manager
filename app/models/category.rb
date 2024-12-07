class Category < ApplicationRecord
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :subcategories, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy
  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validate :depth_within_limit

  scope :ordered, -> { order(id: :desc) }

  after_create_commit -> { broadcast_prepend_later_to 'categories' }
  after_update_commit -> { broadcast_replace_later_to 'categories' }
  after_destroy_commit -> { broadcast_remove_to 'categories' }
  # Those three callbacks are equivalent to the following single line
  broadcasts_to ->(_category) { 'categories' }, inserts_by: :prepend

  MAX_DEPTH = 3 # Set your desired maximum depth here

  private

  def depth_within_limit
    errors.add(:base, "Maximum depth of #{MAX_DEPTH} levels exceeded") if depth >= MAX_DEPTH
  end
end
