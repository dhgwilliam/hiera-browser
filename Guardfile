# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/hiera_browser/(.+)\.rb$})     { |m| "spec/classes/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

end

