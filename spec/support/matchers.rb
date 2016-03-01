require 'rspec/expectations'

RSpec::Matchers.define :be_a_url do |expected|
  match do |actual|
    URI.parse(actual) rescue false
  end
end
