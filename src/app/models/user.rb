class User < ApplicationRecord
  validates :fname, presence: true, length: { minimum: 2 }
  validates :lname, presence: true, length: { minimum: 2 }
  validates :ysalary, presence: true, numericality: { greater_than_equal_to: 1000 }
end
