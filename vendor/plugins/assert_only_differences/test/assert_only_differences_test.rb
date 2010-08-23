require 'test/unit'
require 'rubygems'
require 'active_record'
require 'active_support/test_case'

$:.unshift "#{File.dirname(__FILE__)}/../lib"
require "#{File.dirname(__FILE__)}/../rails/init"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
	ActiveRecord::Schema.define(:version => 1) do
		create_table :foos do |t|
			t.string :name
			t.timestamps
		end
		create_table :bars do |t|
			t.string :name
			t.timestamps
		end
	end
end

def teardown_db
	ActiveRecord::Base.connection.tables.each do |table|
		ActiveRecord::Base.connection.drop_table(table)
	end
end

def reset_db
	teardown_db
	setup_db
end


class Bar < ActiveRecord::Base
end

class Foo < ActiveRecord::Base
end

class AssertOnlyDifferencesTest < ActiveSupport::TestCase

	def setup
		setup_db
	end

	def teardown
		teardown_db
	end

	test "should have no differences when do nothing" do
		assert_only_differences(){}
	end

	test "should have no differences when save nothing" do
		assert_only_differences() do
			Foo.new
		end
	end

	test "should have no differences when create one then destroy one" do
		assert_only_differences() do
			foo = Foo.create
			foo.destroy
		end
	end

	test "should have differences when create one" do
		assert_only_differences("Foo.count" => 1) do
			Foo.create
		end
	end

	test "should have differences when create three" do
		assert_only_differences("Foo.count" => 3) do
			3.times{Foo.create}
		end
	end

	test "should have differences when destroy three" do
		3.times{Foo.create}
		assert_only_differences("Foo.count" => -3) do
			3.times{Foo.first.destroy}
		end
	end

	test "should have differences when create three of multiple models" do
		assert_only_differences({
			"Foo.count" => 3,
			"Bar.count" => 3
		}) do
			3.times{Foo.create}
			3.times{Bar.create}
		end
	end

	test "should have no differences when create three of ignored" do
		Test::Unit::TestCase.ignore_differences = ["Foo"]
		reset_default_differences
		assert_only_differences() do
			3.times{Foo.create}
		end
	end

end
