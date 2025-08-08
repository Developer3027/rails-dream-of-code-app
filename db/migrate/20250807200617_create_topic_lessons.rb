class CreateTopicLessons < ActiveRecord::Migration[8.0]
  def change
    create_table :topic_lessons do |t|
      t.references :topic, foreign_key: true, null: false
      t.references :lesson, foreign_key: true, null: false

      t.timestamps
    end
  end
end
