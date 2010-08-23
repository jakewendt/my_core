$:.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))

require 'markaby'
require 'markaby/rails'

# causes ...
# undefined method `register_template_handler' for ActionView::Base:Class
# ActionView::Base::register_template_handler 'mab', Markaby::Rails::ActionViewTemplateHandler
# changed to ... for Rails 2.?.?
ActionView::Template::register_template_handler 'mab', Markaby::Rails::ActionViewTemplateHandler


ActionController::Base.send :include, Markaby::Rails::ActionControllerHelpers
