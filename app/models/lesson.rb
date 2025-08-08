class Lesson < ApplicationRecord
  belongs_to :course
  has_many :topic_lesson
  has_many :topics, through: :topic_lesson
end
