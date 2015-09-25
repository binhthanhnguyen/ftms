module RailsAdmin
  module Config
    module Actions
      class RemoveSubjectsFromCourse < RailsAdmin::Config::Actions::Base
        register_instance_option :visible? do
          authorized?
        end

        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          "icon-remove"
        end

        register_instance_option :pjax? do
          true
        end

        register_instance_option :http_methods do
          [:get, :post]
        end

        register_instance_option :route_fragment do
          custom_key.to_s
        end

        register_instance_option :action_name do
          custom_key.to_sym
        end

        register_instance_option :custom_key do
          key
        end

        def key
          self.class.key
        end

        register_instance_option :controller do
          Proc do
            @subjects = object.subjects
            if request.post?
              course_params = params.require(:course).permit subject_ids: []
              if object.update_attributes course_params
                flash[:success] = t "admin.actions.updated"
                redirect_to show_course_path(Course, object)
              else
                render "add_trainee_to_course"
                flash[:danger] = t "admin.actions.not_updated"
              end
            end
          end
        end
      end
    end
  end
end
