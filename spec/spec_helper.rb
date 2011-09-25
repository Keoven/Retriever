require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require File.join(
  File.dirname(__FILE__),
  '..', 'lib', 'retriever')
require 'timecop'
require 'active_support'
require 'active_support/time'

RSpec.configure do |config|
  [:all, :each].each do |x|
    config.after(x) do
      Retriever.clean!
    end
  end
end
