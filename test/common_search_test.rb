module CommonSearchTest

  def self.included(base)
		base.extend(ClassMethods)
#		base.instance_eval do
#			include InstanceMethods
#		end
  end 
  
  module ClassMethods

    def add_common_search_unit_tests(model,*args)

			test "should search with no #{model.to_s.pluralize}" do
				records = model.to_s.capitalize.constantize.search()
				assert_equal 0, records.length
			end

			test "should return all #{model.to_s.pluralize} with no params" do
				3.times{Factory(model)}
				records = model.to_s.capitalize.constantize.search()
				assert_equal 3, records.length
			end

			test "should search #{model.to_s.pluralize} by user_id" do
				models = (1..3).collect{|i|Factory(model)}
				records = model.to_s.capitalize.constantize.search(:user_id => models[0].user_id)
				assert_equal 1, records.length
				assert_equal models[0], records[0]
			end

			test "should search #{model.to_s.pluralize} by user login" do
				models = (1..3).collect{|i|Factory(model)}
				records = model.to_s.capitalize.constantize.search(:user => models[0].user.login)
				assert_equal 1, records.length
				assert_equal models[0], records[0]
			end

			test "should search #{model.to_s.pluralize} by exact title" do
				models = (1..3).collect{|i|Factory(model)}
				records = model.to_s.capitalize.constantize.search(:title => models[0].title)
				assert_equal 1, records.length
				assert_equal models[0], records[0]
			end

			test "should search #{model.to_s.pluralize} by partial title 1" do
				models = (1..3).collect{|i|Factory(model, :title => "#{model.to_s} Title #{i}")}
				records = model.to_s.capitalize.constantize.search(:title => "1")
				assert_equal 1, records.length
				assert_equal models[0], records[0]
			end

			test "should search #{model.to_s.pluralize} by partial title 2" do
				models = (1..3).collect{|i|Factory(model, :title => "#{model.to_s} Title #{i}")}
				records = model.to_s.capitalize.constantize.search(:title => "Title")
				assert_equal 3, records.length
			end

			test "should search #{model.to_s.pluralize} by tags as string" do
				models = (1..3).collect{|i|Factory(model, :tag_names => "tag#{i}")}
				records = model.to_s.capitalize.constantize.search(:tags => "tag1")
				assert_equal 1, records.length
				assert_equal models[0], records[0]
			end

			test "should search #{model.to_s.pluralize} by tags as array" do
				models = (1..3).collect{|i|Factory(model, :tag_names => "tag#{i}")}
				records = model.to_s.capitalize.constantize.search(:tags => ["tag1"])
				assert_equal 1, records.length
				assert_equal models[0], records[0]
			end

			test "should search #{model.to_s.pluralize} by not tags as string" do
				models = (1..3).collect{|i|Factory(model, :tag_names => "tag#{i}")}
				records = model.to_s.capitalize.constantize.search(:tags => "!tag1")
				assert_equal 2, records.length
				assert !records.include?(models[0])
			end

			test "should search #{model.to_s.pluralize} by not tags as array" do
				models = (1..3).collect{|i|Factory(model, :tag_names => "tag#{i}")}
				records = model.to_s.capitalize.constantize.search(:tags => ["!tag1"])
				assert_equal 2, records.length
				assert !records.include?(models[0])
			end

			

		end

    def add_common_search_functional_tests(model,*args)

			test "should NOT get search without login" do
				get :index, :title => ""
				assert_not_nil flash[:error]
				assert_redirected_to login_path
			end
		
			test "should search with no params" do
				obj1 = Factory("public_#{model.to_s}")
				obj2 = Factory("public_#{model.to_s}",:title => "Search for me")
				login_as obj1.user
				get :index, :title => ""
				assert_response :success
				assert_template "index"
				assert_not_nil assigns(model.to_s.pluralize)
				assert_equal assigns(model.to_s.pluralize).length, 
					model.to_s.capitalize.constantize.public_and_mine.size
			end
		
			test "should search by title" do
				obj1 = Factory("public_#{model.to_s}")
				obj2 = Factory("public_#{model.to_s}",:title => "Search for me")
				login_as obj1.user
				get :index, :title => "Search for me"
				assert_response :success
				assert_template "index"
				assert_not_nil assigns(model.to_s.pluralize)
				assert_equal 1, assigns(model.to_s.pluralize).length
				assert_equal obj2, assigns(model.to_s.pluralize).first
			end
		
			test "should search by user id array" do
				obj1 = Factory("public_#{model.to_s}")
				obj2 = Factory("public_#{model.to_s}")
				login_as obj1.user
				get :index, :user_id => [obj2.user.id]
				assert_response :success
				assert_template "index"
				assert_not_nil assigns(model.to_s.pluralize)
				assert_equal 1, assigns(model.to_s.pluralize).length
				assert_equal obj2, assigns(model.to_s.pluralize).first
			end
		
			test "should search by user id string" do
				obj1 = Factory("public_#{model.to_s}")
				obj2 = Factory("public_#{model.to_s}")
				login_as obj1.user
				get :index, :user_id => obj2.user.id
				assert_response :success
				assert_template "index"
				assert_not_nil assigns(model.to_s.pluralize)
				assert_equal 1, assigns(model.to_s.pluralize).length
				assert_equal obj2, assigns(model.to_s.pluralize).first
			end
		
			test "should search by user login array" do
				obj1 = Factory("public_#{model.to_s}")
				obj2 = Factory("public_#{model.to_s}")
				login_as obj1.user
				get :index, :user => [obj2.user.login]
				assert_response :success
				assert_template "index"
				assert_not_nil assigns(model.to_s.pluralize)
				assert_equal 1, assigns(model.to_s.pluralize).length
				assert_equal obj2, assigns(model.to_s.pluralize).first
			end
		
			test "should search by user login string" do
				obj1 = Factory("public_#{model.to_s}")
				obj2 = Factory("public_#{model.to_s}")
				login_as obj1.user
				get :index, :user => obj2.user.login
				assert_response :success
				assert_template "index"
				assert_not_nil assigns(model.to_s.pluralize)
				assert_equal 1, assigns(model.to_s.pluralize).length
				assert_equal obj2, assigns(model.to_s.pluralize).first
			end
		
			test "should search by tag as string" do
				obj1 = Factory("public_#{model.to_s}")
				obj2 = Factory("public_#{model.to_s}",:tag_names => "FindMe")
				login_as obj1.user
				get :index, :tags => "FindMe"
				assert_response :success
				assert_template "index"
				assert_not_nil assigns(model.to_s.pluralize)
				assert_equal 1, assigns(model.to_s.pluralize).length
				assert_equal obj2, assigns(model.to_s.pluralize).first
			end

			test "should search by not tag as string" do
				obj1 = Factory("public_#{model.to_s}")
				obj2 = Factory("public_#{model.to_s}",:tag_names => "FindMe")
				login_as obj1.user
				get :index, :tags => "!FindMe"
				assert_response :success
				assert_template "index"
				assert_not_nil assigns(model.to_s.pluralize)
				assert_equal 1, assigns(model.to_s.pluralize).length
				assert_equal obj1, assigns(model.to_s.pluralize).first
			end

			test "should search by tag as array" do
				obj1 = Factory("public_#{model.to_s}")
				obj2 = Factory("public_#{model.to_s}",:tag_names => "FindMe")
				login_as obj1.user
				get :index, :tags => ["FindMe"]
				assert_response :success
				assert_template "index"
				assert_not_nil assigns(model.to_s.pluralize)
				assert_equal 1, assigns(model.to_s.pluralize).length
				assert_equal obj2, assigns(model.to_s.pluralize).first
			end

			test "should search by not tag as array" do
				obj1 = Factory("public_#{model.to_s}")
				obj2 = Factory("public_#{model.to_s}",:tag_names => "FindMe")
				login_as obj1.user
				get :index, :tags => ["!FindMe"]
				assert_response :success
				assert_template "index"
				assert_not_nil assigns(model.to_s.pluralize)
				assert_equal 1, assigns(model.to_s.pluralize).length
				assert_equal obj1, assigns(model.to_s.pluralize).first
			end

			model.to_s.capitalize.constantize.columns.each do |column|
				next if %w( id ).include?(column.name)
#				next if %w( id created_at created_on updated_at updated_on ).include?(column.name)
				next if column.type.to_s == "boolean"
				next if column.name.to_s.match(/_id$/)
				next if column.name.to_s.match(/_count$/)

				cols = case column.type.to_s
					when /(string|text)/   then %w( CCCCC AAAAA BBBBB )
					when /(integer|float)/ then %w( 5000 1000 3000 )
					when /(date|datetime)/ then [ Time.now, Time.now - 3.weeks, Time.now - 1.week ]
				end

				test "should search and sort by #{column.name} DESC" do
					obj1 = Factory("public_#{model.to_s}", column.name => cols[0])
					obj2 = Factory("public_#{model.to_s}", column.name => cols[1])
					obj3 = Factory("public_#{model.to_s}", column.name => cols[2])
					login_as obj1.user
					get :index, :sort => column.name, :dir => "DESC"
					assert_response :success
					assert_template "index"
					assert_equal assigns(model.to_s.pluralize), [obj1,obj3,obj2]
				end

				test "should search and sort by #{column.name} ASC" do
					obj1 = Factory("public_#{model.to_s}", column.name => cols[0])
					obj2 = Factory("public_#{model.to_s}", column.name => cols[1])
					obj3 = Factory("public_#{model.to_s}", column.name => cols[2])
					login_as obj1.user
					get :index, :sort => column.name, :dir => "ASC"
					assert_response :success
					assert_template "index"
					assert_equal assigns(model.to_s.pluralize), [obj2,obj3,obj1]
				end

			end
		end
		alias_method :add_common_search_tests, :add_common_search_functional_tests

	end	#	 module ClassMethods
end	#	 module CommonSearchTest
#Test::Unit::TestCase.send(:include,CommonSearchTest)
ActiveSupport::TestCase.send(:include,CommonSearchTest)
