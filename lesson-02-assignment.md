# Week Two Assignments

## Introduction
In this lesson we will learn about the CRUD actions of Active Record. CRUD stands for Create, Read, Update, and Destroy. We touch on classes and Object Oriented concepts. The idea here is better explained with an example. In general, there is a top level class that other classes can reference. For example you may have a top level class called "Tree". This class would include properties that all tree's would have like trunk, roots, and leaves. You can then have classes for tree types that would reference these properties. For example, a Pine Tree has characteristics of Tree, but it's leaves are very different then say a Oak tree. The barks of the trunk are different, but all have trunks. Some root balls run deep, while others are shallow, but all have roots.

In Rails, [Active Record](https://guides.rubyonrails.org/active_record_basics.html) handles the organization of data within the environment. A Model is a special type of Ruby class that corresponds to a database table. This class handles the logic, the conversation, between Rails and the database. This class is "_an object that wraps a rows in a database table, encapsulates the database access, and adds domain logic to that data_" - [Martin Fowler](https://www.martinfowler.com/eaaCatalog/activeRecord.html). In Rails, Active Record is a ORM, (Object Relational Mapper) that maps access to the database table to the Rails system. There are naming conventions you should be aware of. A model class will have the singular form while the table will be plural. To use a common example, the Book model class is singular. It will relate to the books table in the database. Models will use the UpperCamelCase naming convention while database tables will be snake_case.

### Models and Tables

One of the great things about Ruby is there are any number of ways to accomplish a task. This is no different. The only thing to remember is that for every database table, there needs to be a model and vise versa. It is best to follow Rails convention for this and let Rails handle the set up. Less headaches in the long run. The most straightforward way is to generate a model:
```bash
bin/rails generate model book title:string
```

Here I am using the projects version of rails by calling rails from the bin folder. I call the generate command and tell it to create a model called book. I then provide the attributes I need. In this case just the title with a type of string. Instead of typing out "generate" I can just type "g" and the string type for the attribute is default, so I do not have to state it, if it is a string.

Here is the generated output:
```bash
      invoke  active_record
      create    db/migrate/20250715231332_create_books.rb
      create    app/models/book.rb
      invoke    test_unit
      create      test/models/book_test.rb
      create      test/fixtures/books.yml
```

As you can see, Rails will create the migration to create the database table as well as create the book model. Running ```bin/rails db:migrate``` here will run the migration and create the table.

When the Rails app is generated, a ApplicationRecord class is created. This is what turn the regular Ruby class into an Active Record model. New models will inherit from this class and have access to the CRUD actions and many other properties.

### Manage Data

Command to Create a new record in database table:
```bash
Trimester.create(year: '2026', term: 'Spring', application_deadline: '2026-02-15', start_date: "2026-03-01", end_date: "2026-06-30")
```

The above command will create a new trimester in the trimester table using the create method. If using the _new_ method, it will return a new, non-persisted object. This means that using _new_ will place the data for the new object in memory, but will **not save** it to the database. Using _create_ **will save** the object to the database and return it. Let's take a look at how the above could be initialized, then saved to the database:

```ruby
spring_trimester = Trimester.new

spring_trimester.year = 2026
spring_trimester.term = "Spring"
spring_trimester.application_deadline: "2026-02-15"
spring_trimester.start_date: "2026-03-01"
spring_trimester.end_date: "2026-06-30"

spring_trimester.inspect

spring_trimester.save
```


