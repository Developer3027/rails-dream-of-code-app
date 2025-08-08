class TopicLesson < ApplicationRecord
  belongs_to :topic
  belongs_to :lesson
end
