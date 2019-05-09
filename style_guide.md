# General

- Be consistent
  > If you're editing code, take a few minutes to look at the code around you and determine its style. If they use spaces around all their arithmetic operators, you should too. If their comments have little boxes of hash marks around them, make your comments have little boxes of hash marks around them too.
  > The point of having style guidelines is to have a common vocabulary of coding so people can concentrate on what you're saying rather than on how you're saying it. We present global style rules here so people know the vocabulary, but local style is also important. If code you add to a file looks drastically different from the existing code around it, it throws readers out of their rhythm when they go to read it. Avoid this.
- Avoid long methods, break up into smaller pieces
- Avoid long parameter lists
- Avoid needless metaprogramming

# Formatting

- UTF-8 as source file encoding
- No tabs
- Use 2 space indent in all rb & erb files
- Use 4 space indent for javascript
- Avoid using semicolons to separate statements/expressions - one expression per line
- Avoid single line methods
- Generally use spaces around operators, after commas, colons and semicolons. 
- Use spaces around `{}` 
- No space after `!`    
- No space inside range literals
- Use empty lines around access modifiers
- Single empty line between method definitions
- Avoid long lines that span more then a screen length, break up logically

        # Bad
        Mailer.deliver(to: 'bob@example.com', from: 'us@example.com', subject: 'Important message', body: source.text)
        
        # Good
        Mailer.deliver(to: 'bob@example.com', from: 'us@example.com', 
                       subject: 'Important message', body: source.text)
        
        # Good
        Mailer.deliver(
            to: 'bob@example.com',
            from: 'us@example.com',
            subject: 'Important message',
            body: source.text,
        )
- Align elements of array literals spanning multiple lines
- Generally, try to limit lines by 120 characters
- Avoid trailing whitespace (configure editor properly)
- Avoid block comments

        # bad
        =begin
        comment line
        another comment line
        =end

        # good
        # comment line
        # another comment line

# Syntax

- Use def with parentheses when there are parameters, omit parentheses when the method doesnt accept any parameters
- Use `&&`/`||` instead `and`/`or`  and `!` instead `not` (Introduces subtle bugs because of precedence issues)
- Favour `unless` over `if` for simple negative conditions, use `if` if the statement
  is complex.
- Do not use parentheses around the condition of a control expression
- Do not use unless with else. Rewrite these positive case first.
- Prefer always using parentheses in method calls with 1 or more arguments
- Always use parentheses for method calls with multiple arguments
- Omit parentheses for method calls with zero arguments
- Use proc invocation shorthand when the invoked method is only operation of a block

        # bad
        names.map { |name| name.upcase }
        
        # good
        names.map(&:upcase)
        
- Prefer {...} over do...end for single-line blocks. Avoid using {...} for multi-line blocks. Always use do...end for “control flow” and “method definitions” (e.g. in Rakefiles and certain DSLs). Avoid do...end when chaining.
- Avoid return where not required
- Do not put a space between a method name and the opening parenthesis.
- Use the new lambda literal syntax.
    
        # bad
        l = lambda { |a, b| a + b }
        l.call(1, 2)
        
        l = lambda do |a, b|
          tmp = a * 7
          tmp * b / 50
        end
        
        # good
        l = ->(a, b) { a + b }
        l.call(1, 2)
        
        l = ->(a, b) do
          tmp = a * 7
          tmp * b / 50
        end
        
- Don't omit the parameter parentheses when defining a lambda with parameters.
- Omit the parameter parentheses when defining a lambda with no parameters.
- Use `_` for unused parameters
- Prefer a guard clause when you can assert invalid data. A guard clause is a 
  conditional statement at the top of a function that bails out as soon as it can.
         
         # bad
         def foo(a)
           if a.present?
             # do some stuff
           else
             # return 
         end
  
         # good
         def foo(a)
           return unless a.present?
           
           # do some stuff
         end
  
- Prefer keyword arguments over options hash
- Prefer keyword arguments over optional arguments
- Favor the use of predicate methods to explicit comparisons with ==
- Use keyword arguments when for boolean parameters
- Do not use then for multi line if/unless
- Always put the condition on the same line as the if/unless in a multi-line conditional

# Naming

- Use snake_case for symbols, methods and variables.
- Use snake_case for naming files and directories, e.g. hello_world.rb
- Use CamelCase for classes and modules (keep acronyms like HTTP, RFC, XML uppercase)
- Aim to have just a single class/module per source file. Name the file name as the class/module, but replacing CamelCase with snake_case
- The names of predicate methods (methods that return a boolean value) should end in a question mark (i.e. Array#empty?). Methods that don’t return a boolean, shouldn’t end in a question mark.
- Avoid magic numbers. Use a constant and give it a useful name
- Method names should not be prefixed with is_. E.g. prefer empty? over is_empty?

# Comments

- Use one space between the leading # character of the comment and the text of the comment
- Generally use proper capitalization & punctuation
- Good comments focus on the reader of the code, by helping them understand the code. The reader may not have the same understanding, experience and knowledge as you. As a writer, take this into accou
- Focus on why your code is the way it is if this is not obvious, not how your code works
- Avoid writing comments to explain bad code. Refactor the code to make it self-explanatory. 
- Avoid superfluous comments. If they are about how your code works, should you clarify your code instead?

        # bad
        counter += 1 # Increments counter by one.

- A big problem with comments is that they can get out of sync with the code easily. When refactoring code, refactor the surrounding comments as well.
- Never leave commented out code

# Classes & Modules

- Prefer modules to classes with only class methods. Classes should be used only when it makes sense to create instances out of them.
- Favour the use of extend self over module_function when you want to turn a module’s instance methods into class methods.
- Prefer using a `class << self` block over `def self.` when defining class methods, and group them together within a single block.
- Use the attr family of methods to define trivial accessors or mutators

# Collections

- Prefer literal array and hash creation notation (unless you need to pass parameters to their constructors, that is).

        # bad
        arr = Array.new
        hash = Hash.new

        # good
        arr = []
        hash = {}

- When accessing the first or last element from an array, prefer first or last over [0] or [-1].
- Use the Ruby 1.9 hash literal syntax when your hash keys are symbols.

       // bad
       h = { 
         :k1 => 'v1',
         :k2 => 'v2'
       }

       // good
       h = { 
         k1: 'v1',
         k2: 'v2'
       }

- Don’t mix the Ruby 1.9 hash syntax with hash rockets in the same hash literal.
  When you’ve got keys that are not symbols stick to the hash rockets syntax.
- Use `Hash#key?` instead of `Hash#has_key?` and `Hash#value?` instead of `Hash#has_value?`.
  The longer forms are considered deprecated.
- Use Hash#fetch when dealing with hash keys that should be present.

        heroes = { batman: 'Bruce Wayne', superman: 'Clark Kent' }
        # bad - if we make a mistake we might not spot it right away
        heroes[:batman] # => "Bruce Wayne"
        heroes[:supermann] # => nil

        # good - fetch raises a KeyError making the problem obvious
        heroes.fetch(:supermann) 
        
- Introduce default values for hash keys via Hash#fetch as opposed to using custom logic.
- Closing `]` and `}` must be on the line after the last element when opening brace is on a separate line from the first element.


# Strings

- Closing ] and } must be on the line after the last element when opening brace is on a separate line from the first element.
- Prefer string interpolation and string formatting instead of string concatenation:

        # bad
        email_with_name = user.name + ' <' + user.email + '>'

        # good
        email_with_name = "#{user.name} <#{user.email}>"

        # good
        email_with_name = format('%s <%s>', user.name, user.email)
- With interpolated expressions, there should be no padded-spacing inside the braces.
- Always use single quotes whenever there is no string interpolation

# Rspec

- [rspec style guide](https://github.com/rubocop-hq/rspec-style-guide)
  This guide pretty much covers everything
  
# Rails

 - Use `presence` over `present`/`blank` when applicable

       # bad
       a.present? ? a : nil

       # bad
       !a.present? ? nil : a

       # bad
       a.blank? ? nil : a

       # bad
       !a.blank? ? a : nil

       # good
       a.presence

 - Use `present?` to keep conditions simpler when applicable

       # bad
       !foo.nil? && !foo.empty?

       # bad
       foo != nil && !foo.empty?

       # bad
       !foo.blank?

       # bad
       not foo.blank?

       # bad
       something unless foo.blank?

       # good
       foo.present?

       # good
       foo.present?

       # good
       something if foo.present?

 - Use `blank?` to keep conditions simpler when applicable

       # bad
       foo.nil? || foo.empty?
       foo == nil || foo.empty?

       # bad
       something unless foo.present?

       # good
       something if foo.blank?

        # bad
       unless foo.present?
         something
        end

       # good
       foo.blank?

       # good
       if foo.blank?
         something
       end

       # good
       def blank?
         !present?
       end

 - Use the safe navigation (`&.`) operator over `try` when applicable

       # bad
       foo.try!(:bar)
       foo.try!(:bar, baz)
       foo.try!(:bar) { |e| e.baz }
       foo.try(:bar)
       foo.try(:bar, baz)
       foo.try(:bar) { |e| e.baz }

       # good
       foo&.bar
       foo&.bar(baz)
       foo&.bar { |e| e.baz }

 - Use `User.find_by(name: 'Bruce')` over `User.where(name: 'Bruce').first`

       # bad
       User.where(name: 'Bruce').first
       User.where(name: 'Bruce').take

       # good
       User.find_by(name: 'Bruce')

 - Use `User.all.find_each` over `User.all.each`. 
  The later has [performance issues](https://stackoverflow.com/questions/30010091/in-rails-whats-the-difference-between-find-each-and-where)

       # bad
       # loads the entire result of User.all into memory
       User.all.each

       # good
       # loads in batches
       User.all.find_each


# Javascript

- Always terminate lines with semicolons
- Use Java brace style for blocks
  
        function foo() {
          // some code
          // more code
        }
        
        if (a == b) {
          // some code
          // more code
        }
         
- For one line blocks, omit braces         

        if (a == b)
          // do some stuff
        
- Prefer using `const` or `let`, avoid `var` for variable declaration. 
  `var` declares a global variable, we want to avoid polluting the global namespace
- Use single quotes for strings
- Use 4 spaces for javascript, dont use tabs
- Use dot notation for accessing properties

        const h  = {
            k1: 'v1',
            k2: 'v2'
        };
        
        // bad
        h['k1'];
        
        // good
        h.k1;
        
- Use bracket notation when accessing properties with a variable
        
        const h  = {
            k1: 'v1',
            k2: 'v2'
        };
        
        key = 'k1';
        h[key];
        
- Use `/** ... */` for multi line comments

       // bad
       // multi line comment
       // another line
       
       // good
       /*
        *
        *
        */
