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

The above command will create a new trimester in the trimester table using the create method. If using the _new_ method, it will return a new, non-persisted object. This means that using _new_ will place the data for the new object in memory, but will **not save** it to the database. Using _create_ **will save** the object to the database and return it. Let's take a look at how the above could be initialized, then saved to the database with _new_:

First let's look at the last record in the database for Trimester. We want this as a reference. Running ```Trimester.last``` shows us the last record in the database. You can run this again after creating the new trimester, without calling _save_, to verify if the _new_ record has been added to the database.

```ruby
spring_trimester = Trimester.new

spring_trimester.year = 2026
spring_trimester.term = "Spring"
spring_trimester.application_deadline = "2026-02-15"
spring_trimester.start_date = "2026-03-01"
spring_trimester.end_date = "2026-06-30"

spring_trimester.inspect

spring_trimester.save
```

Run the above in the console **_without_** the save action. You will see the new trimester object without the id, rather the id is _nil_. Here we have created a instance of the new record in memory. It has not been saved to the database yet

 Now run ```spring_trimester.save``` and review the last record in Trimesters. You should see the new record with the id. Now the record is saved to the database.

 If a record is already created we can call the _update_ method on it to modify the data of specific attributes. Let's walk through a typical create and update situation.

 ### Create and Update of new Mentor

 A new volunteer, Frank Smith, has signed up to be a mentor. His email is _frank.smith@test.com_. Let's create a new record for him in the database. First let's look at the attributes of the mentor record to make sure we have all the info we need.

 ```ruby
 Mentor.last
 ```

 Here is the object we got back:
 ```bash
 #<Mentor:0x00007e716347eed0
 id: 30,
 first_name: "Yoko",
 last_name: "Abbott",
 email: "[FILTERED]",
 max_concurrent_students: nil,
 created_at: "2025-07-10 17:29:23.609261000 +0000",
 updated_at: "2025-07-10 17:29:23.609261000 +0000">
 ```
 Now we know we do not have all the information for the record, but we have plenty to create the record. We will make Frank a mentor like this:

 ```ruby
 Mentor.create(first_name: "Frank", last_name: "Sith", email: "frank.smith@test.com")
 ```
 You hit enter and review the returned object. But wait! Have you just sent Frank to the dark side?! We need to correct the last name typo as quick as possible. Who knows what Frank is capable of. First let's put the record in a variable we can use.

 ```ruby
 Frank = Mentor.last
 ```

 This worked! Can you imagine why this is probably not the best way to get Frank? Is there a more robust way, maybe using _find_?

 Now that we have "Frank" we can update his last name like this. Now "Frank" is the mentor record and has all it's attributes. We can update "Frank" like this:

 ```ruby
 Frank.update(last_name: "Smith")
 ```

 Let's see if the record got updated by checking the last mentor again:

 ```ruby
 Mentor.last
 ```

 ```bash
 #<Mentor:0x00007e716347ed90
 id: 31,
 first_name: "Frank",
 last_name: "Smith",
 email: "[FILTERED]",
 max_concurrent_students: nil,
 created_at: "2025-07-17 16:19:22.073592000 +0000",
 updated_at: "2025-07-17 16:27:55.600738000 +0000">
doc-rails(dev)>
```

Looks like we may have dodged a bullet with that one. Hopefully Frank did not learn how to use his lightening fingers in the past few moments. Bet that will make the news. Now that Frank is here and ready to help, let's give him someone to help. Mentor 22 has a new puppy that is very demanding. He has asked for his work load to be reduced. Why not give Frank one of mentor 22's students?

How many assignments does mentor 22 have? let's see:

```ruby
mentor_22 = MentorEnrollmentAssignment.where(mentor_id: 22)
```

If we want to know the number we can add the _count_ method to the end. Or we can call _count_ on the new variable we just created.

```ruby
mentor_22.count
```

Mentor 22 is stacked up! let's grab the last one:

```ruby
franks_assignment = mentor_22.last
```

Now let's make sure we get Frank and use _find_by_:
```ruby
Frank = Mentor.find_by(email: "frank.smith@test.com")
```

Do we know what Franks id number is?

```ruby
Frank.id
```

Great! So let's move mentor 22s assignment to Frank:
```ruby
franks_assignment.update(mentor_id: Frank.id)
```

There you go! Now Frank has a new assignment and mentor 22 can take more time with the puppy. Even the universe is safer with no Sith lords around. Best day ever!

## Question 1

Remember when we created the spring trimester for 2026? Well it would be great if you could create a new course, to include all the coding classes, for the spring class. Here are some tips:

* You may want to loop through the list of coding classes similar to how we looped through courses in lesson 1.
* You'll be creating courses similar to how we created a Trimester in this lesson.
* Test your .create statement (in the rails console) before including it in your loop.
* Also, test your loop with a puts statement before running the loop with the create statement.
* When you feel confident about both the loop syntax and the create statement, then put them together and execute your loop in the rails console.
* If you accidentally create a course record that you'd like to delete, you can use the .destroy method. First use a finder method to retrieve the course instance and then call .destroy on that instance.

Let's take a look at the attributes of a course:
```ruby
Course.last
```
Will present this object:
```bash
#<Course:0x0000762cbdcede10
 id: 35,
 coding_class_id: 5,
 trimester_id: 7,
 max_enrollment: 25,
 created_at: "2025-07-10 17:29:11.408178000 +0000",
 updated_at: "2025-07-10 17:29:11.408178000 +0000">
```
Fantastic! We know the _id_, _created_at_ and _updated_at_ attributes are automatic, so don't have to worry about those. That _trimester_id_ was created when we made the spring trimester! I will assume that the max size for enrollment is 25. I wonder how many _coding_class_ there are?

```ruby
CodingClass.count
```

Great! There are 5 total. Do I need specific information about those classes? Not really, Just the id of each is listed in the course object. I can use the coding class objects as a reference to how many times I need to loop to create the new courses! I can say something like:

```
coding_class each |class|
  course.create(
    coding_class_id = class.id, 
    trimester_id = spring_trimester.id,
    max_enrollment = 25 )
end
```

This looks ok. I do not need to filter coding class as I want all of them. I do need to create a collection with _all_ like this: ```CodingClass.all```. Then that "class.id" should return the coding_class id for each loop. I should verify the "spring_trimester.id". Let's print this out to see what it does:

```ruby
all_classes.each do |klas|
    puts "coding_class_id = #{klas.id}," 
    puts "trimester_id = #{spring_trimester.id},"
    puts "max_enrollment = 25"
    puts ""
end
```

That looks good. Probably best to wrap this with some error handling. That way if there is a problem we have some idea of what happened and we don't hurt anything.

```ruby
all_classes.each do |klas|
  begin
    Course.create(
      coding_class_id: klas.id,
      trimester_id: spring_tri_xxvi.id,
      max_enrollment: 25
    )
  rescue StandardError => e
    puts "error: #{e.message}"
  end
end
```

No errors, looks good. Let's take a look at the new stuff. Gather a new collection for the courses of spring of 26 like ```spring_courses = Course.where(trimester_id: spring_tri_xxvi)```. Now I can review "_spring_courses_"

## Question 2