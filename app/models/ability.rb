class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new

    if user.admin?
      can :access, :rails_admin
      can :dashboard
      can :manage, User
    elsif user.supervisor?
      can :access, :rails_admin
      can :dashboard
      can :destroy, :all
      can :export, :all
      can :index, :all
      can :new, :all
      can :edit, :all
      can :show_in_app, :all
      can :show, :all
      cannot [:create, :update, :destroy], User
      can :start_course, Course do |course|
        course.init?
      end
      can :finish_course, Course do |course|
        course.progress?
      end
      can :show_course, Course
      can :finish_course_subject, Course
      can :start_course_subject, Course
      can [:index, :show, :update], UserSubject
      can [:edit, :update], User, id: user.id
      can [:add_trainee_to_course, :add_subjects_to_course], Course do |course|
        !course.finish?
      end
      can :show_subject, Subject
    else
      can [:index, :show], Course
      can [:index, :show], Subject
      can [:index, :show, :update], UserSubject
      can [:edit, :update], User, id: user.id
      can :show, User
    end
  end
end
