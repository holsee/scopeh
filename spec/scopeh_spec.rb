require "rspec"
require "./src/scopeh"

describe Container do

  before(:each) do
    @container = Container.new
  end

  it "raises NotRegisteredError when symbol not registered to class" do
    expect { @container.resolve(:wizz) }.to raise_error
  end

  it "registers the symbol against the Class" do
    @container.register :foo, Foo
    @container.registry[:foo].should eql({:klass => Foo, :scope => :per_resolution})
  end

  it "resolves klass instance from container" do
    @container.register :foo, Foo
    foo = @container.resolve(:foo)
    foo.should be_a_kind_of(Foo) 
  end

  it "resolves new instance of dependencies" do
    @container.register :foo, Foo
    @container.register :bar, Bar
    bar = @container.resolve(:bar)
    bar.foo.should be_a_kind_of(Foo) 
  end

  it "should allow registration as singleton" do
    @container.register :foo, Foo, :singleton
    f00 = @container.resolve :foo
    foo = @container.resolve :foo
    f00.should be(foo)
  end

  it "should allow registration as thread safe singleton which creates new instance per thread" do 
    @container.register :foo, Foo, :singleton_per_thread
    
    foo = nil
    f00 = nil

    count = 2
    Thread.start do
     foo = @container.resolve :foo
     count -= 1
    end

    Thread.start do
      f00 = @container.resolve :foo
      count -= 1 
    end

    while count > 0
    end

    f00.should_not be(foo)
  end

  it "should allow registration as thread safe singleton which returns same instance in thread" do 
    @container.register :foo, Foo, :singleton_per_thread
    
    foo = @container.resolve :foo
    f00 = @container.resolve :foo

    f00.should be(foo)
  end

end

class Foo
end

class Bar
  attr_reader :foo

  def initialize(foo)
    @foo = foo
  end
end


# def thread_singleton()
#   #note, don't  actually make MyOnePerThreadClass a "real"  singleton
#   Thread.current["my singleton"] ||= MyOnePerThreadClass.new 
# end

# # Exercise per thread scope...

# Thread.start do
#   thread_singleton.send_some_message
# end

# Thread.start do
#   thread_singleton.send_other_message 
#   # a different singleton for this thread than the other thread, 
#   # but will be the same for the duration of this thread
# end

