class Topic < ApplicationRecord
  # has_many :lessons
  has_many :topic_lesson
  has_many :lessons, through: :topic_lesson
end
