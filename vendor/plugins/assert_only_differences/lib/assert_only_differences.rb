#
#	Assert Only Differences (everything else remains the same)
#
#	Add any models to ignore in your test_helper.rb like so
#	  class Test::Unit::TestCase
#		 self.ignore_differences = ["IgnoreMe"]
#
#	Use me like so ...
#		assert_only_differences() {
#		  do_something_that_should_not_change_anything();
#		}
#
#		assert_only_differences({
#			  "users(:me).stuff.reload.size" => 5
#		  }) {
#		  do_something_that_should_not_change_anything_except_my_stuff();
#		}
#
class Test::Unit::TestCase

#	class_inheritable_accessor :ignore_differences
#	class_inheritable_accessor :add_differences

	#	can't extend the normal way that I'm used to because of 
	#	these cattr_accessor calls ...
	cattr_accessor :ignore_differences
	cattr_accessor :add_differences

	self.ignore_differences = []
	self.add_differences = {}

	#	This is excessive!  But I love it!
	#	Set all these defaults here then when you call
	#	assert_only_differences() {
	#		do_something_stupid()
	#	}
	#	it will ensure that nothing was added (net count)
	#	(if something was added and something else was removed you'll never know.)
	def assert_only_differences(differences={}, &block)
		all_differences = default_differences.merge(differences)
		assert_differences(all_differences.to_a) do
			yield
		end
	end

	def reset_default_differences
		@@default_differences = {}
	end

private

	def default_differences()
		#	generate a big hash containing model names and the
		#	default expected change (usually 0).
		#	ex.  { 'News.count' => 0, 'User.count' => 0 }
		@@default_differences ||= (
			ddhash = {}
#	This does 'eval("defined?(::#{k}) && ::#{k}.object_id == k.object_id"))'
#		where k is and class and #{k} is class.to_s which can be overridden
#		and then mucks this up.  I could completely override the Object.subclasses_of
#		method, but I don't want to do that (just yet) so I'll just rip out what I
#		need and put it here.
#			Object.subclasses_of(ActiveRecord::Base).each do |ar|
#	Board.to_s returns "Magnetic Poetry Board" so don't do this.
#				if ar.connection.active? and ar.table_exists? and !ignore_differences.include?(ar.to_s)
			ObjectSpace.each_object(class << ActiveRecord::Base; self; end) do |ar|
				next if ar.name == 'ActiveRecord::Base'
				if ar.connection.active? and ar.table_exists? and !ignore_differences.include?(ar.name)
					ddhash["#{ar.name}.count"] = 0
#					ddhash["#{ar.name}.next_id"] = 0
				end
			end
			ddhash.merge(add_differences)
		)
	end

	def assert_differences(differences=[], &block)
		this_diff = differences.pop
		if this_diff.blank?
			yield
		else
			assert_difference( this_diff[0], this_diff[1], "#{this_diff[0]} should've changed by #{this_diff[1]}" ) do
				assert_differences(differences) { yield }
			end
		end
	end

end
