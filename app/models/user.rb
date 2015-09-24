class User < ActiveRecord::Base
  include RailsAdminUser
  has_many :user_courses, dependent: :destroy
  has_many :user_subjects, dependent: :destroy
  has_many :user_tasks, dependent: :destroy
  has_many :courses, through: :user_courses
  has_many :subjects, through: :user_subjects
  has_many :tasks, through: :user_tasks

  devise :database_authenticatable, :rememberable, :trackable, :validatable
  enum role: [:admin, :supervisor, :trainee]

  scope :free_trainees, ->{self.trainee.where "id NOT IN (SELECT user_id
    FROM user_courses JOIN courses ON user_courses.course_id = courses.id
    WHERE courses.status = 0 OR courses.status = 1)"}

  private
  def password_required?
    new_record? ? super : false
  end
end
