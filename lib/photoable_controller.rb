# add "include PhotoableController" to application_controller.rb
module PhotoableController
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    
    def add_photoability(object_name)
      # add_photoability :stop
      before_filter :require_photo_owner, :only => [ :attach_photo, :detach_photo ]

      define_method "require_photo_owner" do
        @photo = Photo.find(params[:photo_id])
        unless ( logged_in? && ( ( current_user.id == @photo.user.id ) || current_user.has_role?('administrator') ) ) 
          permission_denied
        end
      end

      define_method "create_photo" do
        @photoable = instance_variable_get("@#{object_name}")
        @photo = @photoable.photos.new(params[:photo])
        @photo.user_id = current_user.id
        if @photoable.save
          render :update do |page|
            page.insert_html :bottom, "photos", :partial => 'photos/edit', :locals => { :photo => @photo }
            page.visual_effect :highlight, dom_id(@photo), :duration => 1
          end
        else
#	TODO
#	I should add some RJS here 
#
					flash.now[:error] = "Photo creation failed."
          render :text => ''
        end
      end

      define_method "attach_photo" do
        @photoable = instance_variable_get("@#{object_name}")
        @photoable.photos << @photo   # why do I not need a save after this?
        render :update do |page|

        end
      end

      define_method "detach_photo" do
        @photoable = instance_variable_get("@#{object_name}")
        PhotoablesPhoto.find(:first,:conditions => { 
          :photo_id => params[:photo_id],
          :photoable_id => @photoable.id,
          :photoable_type => @photoable.class.to_s
        }).destroy      # could be more than one, although highly unlikely
        render :update do |page|
          page.remove dom_id(@photo)
        end
      end

    end
  end
end
