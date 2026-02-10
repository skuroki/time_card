module PropertyTesting
  # Define property_test as a class method that can be used in describe blocks
  def property_test(description, iterations: 100, &block)
    it description do
      iterations.times do |i|
        instance_exec(i, &block)
      end
    end
  end
end

RSpec.configure do |config|
  config.extend PropertyTesting
end
