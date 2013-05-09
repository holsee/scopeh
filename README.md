Scopeh
======
### 'an ioc container in ruby for the craic'

* resolves dependencies (manages dependency tree)
* register types against symbols
* scoping allows object lifetime management, including singleton and per thread scope


#### CONTRIBUTION
I would love work with/pair with an experienced Rubyist... get in touch!

<div align="center">
<a href="mailto:me@stevenholdsworth.co.uk?subject=PAIR-PROG-REQ-[Scopeh]" style="">
<img src="http://holsee.com/wp-content/uploads/2013/04/badge.png" alt="Pair program with me!" scale="0">
</a>
</div>

### USAGE

#### REGISTRATION

```ruby
    @container.register :foo, Foo
```

#### RESOLUTION

```ruby
    @container.register :foo, Foo
    foo = @container.resolve(:foo)
```

#### IMPLICIT DEPENDENCY RESOLUTION

```ruby
    class Foo
    end

    class Bar
      attr_reader :foo

      def initialize(foo)
        @foo = foo
      end
    end

    @container.register :foo, Foo
    @container.register :bar, Bar
    bar = @container.resolve(:bar)
```

#### SCOPES

##### SINGLETON

```ruby
    @container.register :foo, Foo, :singleton
    @container.resolve :foo   #<Foo:0x007fb30ab34e20>
    @container.resolve :foo   #<Foo:0x007fb30ab34e20>
```

##### SINGLETON PER THREAD

```ruby
    @container.register :foo, Foo, :singleton_per_thread

    Thread.start do
      @container.resolve :foo   #<Foo:0x007fb30ab34e20>
      @container.resolve :foo   #<Foo:0x007fb30ab34e20>
    end

    Thread.start do
      @container.resolve :foo    #<Foo:0x007fea5382b9d8>
    end
```

#### A WORD OF WARNING
This is an _Experimentation_ of ioc container for ruby, this hasn't been tested in anger, nor have I profiled this for memory leaks.  Do whatever you like with it, this is MIT licensed but note this is potentially not a very idomatic approach.

#### LICENSE (MIT)

Copyright (C) 2013 Steven Holdsworth

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

