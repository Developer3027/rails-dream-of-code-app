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
      trimester_id: spring_trimester.id,
      max_enrollment: 25
    )
  rescue StandardError => e
    puts "error: #{e.message}"
  end
end
```
No errors, looks good. Let's take a look at the new stuff. Gather a new collection for the courses of spring of 26 like ```spring_courses = Course.where(trimester_id: spring_tri_xxvi)```. Now I can review "_spring_courses_"

## Question 2

* Create a new student record and enroll the student in the Intro to Programming course for the Spring 2026 trimester.

What attributes does a "student" have?
```ruby
Student.first
```
Create me as a student:
```ruby
Student.create(
  first_name: "Mason",
  last_name: "Roberts",
  email: "mason.roberts@test.com")
```
Maybe set me:
```ruby
mason = Student.find_by(email: "mason.roberts@test.com")
```
What is the "intro to programming" class id?
```ruby
CodingClass.find_by(title: "Intro to Programming")
```
That id is 1. What is the id for spring trimester of 26?
```ruby
Trimester.where(year: "2026", term: "Spring")
```
That id is 8. What is the course id for the into to programming course for the spring of 2026?
```ruby
Course.where(coding_class_id: 1, trimester_id: 8)
```
That id is 36. Enrollment needs course id and student id. Do I have those? course_id = 36 / student_id = 51 (mason.id). I can add me to the intro to programming course for the spring of 2026. First let's check to see if I am already there.
```ruby
Enrollment.where(course_id: 36, student_id: 51)
```
That returned an empty collection, or array, so let's get me enrolled.
```ruby
Enrollment.create(course_id: 36, student_id: 51)
```
The record returned:
```bash
#<Enrollment:0x00007e3f2844d488
 id: 91,
 course_id: 36,
 student_id: 51,
 final_grade: nil,
 created_at: "2025-07-17 20:13:11.387750000 +0000",
 updated_at: "2025-07-17 20:13:11.387750000 +0000">
doc-rails(dev)>
```

* Find a mentor with no more than 2 students (enrollments) assigned and assign that mentor to your new student's enrollment.

There are 31 mentors and 90 mentor enrollment assignments. I need to loop through the mentor enrollment assignments. For every mentor, I need to collect that mentors enrollments. I then need to find the mentors with 2 or less enrollments and collect them with there counts.

Create an array to put mentors in.
```ruby
found_em = []
```
Loop through the mentors and gather those mentors with no more than 2 assignments.
```ruby
mentors.each do |mentor|
  mint = MentorEnrollmentAssignment.where(mentor_id: mentor.id)
  if mint.count <= 2
    entry = "mentor id: #{mentor.id}, email: #{mentor.email}: has #{mint.count} assignments."
    found_em << entry
  end
end
```
Call that array of mentors to see what I caught
```ruby
found_em
```

Looks like mentor 22 only has 2 assignments, but previously we lightened that load because of the puppy. That being the said, looks like Frank gets punished. Sorry Frank. I can use _find_or_create_by_ or _upsert_ to make sure there is no previous record. If you need to get fancy, use upsert, otherwise, find_or_create_by is the default.
```ruby
MentorEnrollmentAssignment.find_or_create_by(mentor_id: 31, enrollment_id: 91)
```

## Question 3
**Describe your Project**

I have been back and forth on this. I have a idea for a school that I could simply use this course work to make it. I have a great design for a recipe app that would be fun. I have the Zune player that I love to tinker with. However, I have landed on the one above all. The one that never gets done. The one that picks at the edges of my dreams. The one I have tried to start over and over. The one I am scared of. The one that I want above all others.

**Welcome Hermit Plus**

Over the years it has been a dream. I have picked at it from time to time. I have started and stopped. Never made real headway. Rails is the platform that will give this build some respect. I feel confident enough in Rails to give this a full go. What is Hermit Plus? Allow me. Minecraft is an amazing game. It allows for games within the game. It allows for programming your own features into the game. It is like no other. There are a group of people called Hermits that play together on the same server. It is called hermitcraft. They have really hit on a niche. They all play together on a server for a season. During that season they interact and follow some story line they put together. There are hermits that are amazing builders and others who are crazy at redstone. At the end of the season they have a fully grown and built server that others can purchase. They are YouTube content providers and many use twitch for live stream.

What I have always wanted was a platform just for them. Think Netflix but for just the Hermits. This is a ban-aid to the bigger problem for content providers, but this is a stepping stone to that solution. A big one if I am honest. Hermit Plus is a streaming web app that includes just the Hermits of Hermitcraft. It would use the YouTube API to get video content from YouTube. There needs to be a connection there. My goal is to separate the Hermits from the noise of YouTube, but never substitute the platform. Rather I want to use YouTube as storage for the videos. I would use the API to grab subscriptions and pass likes as well. This would need a service to regularly verify links still work and such.

I want to build a platform that allows each Hermit the opportunity to shine like they should. Personally I want to be able to better track and enjoy the friendships between them from season to season. I want to better enjoy the fan art for the characters, or be able to get character specs, see there skins.

Personally I feel that season 8 is great. For anyone visiting, they would be a guest, and would have access to season 8. Every Hermit should have an account for there character. There has to be a master admin that can manage the entire site. There will be two levels of user past the guest. One can view all content, and one that can upload art, music, skins, maps, and such. Some of that would be links of course. This is a media streaming app at it's heart, for the Hermits, not a social app. At least MVP will not be an in depth social app.

I have looked at the YouTube API and somewhat understand it. Also have researched the wiki API thinking it would be useful here. The Hermits do have a fan wiki running through the Fandom wiki. That is a bit of a mess.

As for MVP I want a environment loaded full of Hermitcraft. A expandable sidebar for navigation. Main page will have scrolling banner along the top for each hermit. Large cards under for the different groups. Single video thumbs of the first episode of season 8 underneath for each hermit.

**The Hermit Model**


## Question 4

## Mindset Question
What do I think about AI and AI Tools in Programming.

AI is easily accessible today in many aspects of out lives. As for coding or programming, it has become very integrated as you can get extensions like Wavesurfer, or vsCode has CoPilot integrated right in. There are many platforms to choose from such as Googles Gemini to DeepSeek. My point is that it is there and available. There is no running from it.

I tend to use it as my personal mentor when coding. Often I run through concerns that I am do not completely understand and I use DeepSeek to better understand these concerns. For me it is an amazing tool that I never had access before in developing web apps. It still has it's problems. I used it heavily to try and create the table of contents service for my blob, built in Rails. It took roughly 6 months to get it working. In the end it was a "idea" for a test I had that found the problem and allowed for a working service. It would still be a jumble of code snippets and ideas if not for AI though. It is difficult for a hobbyist or junior developer to get along and move forward with there own concept using just the docs. At least that has been my experience. AI has gave me a sense that my code has grown and matured.

Problem in this situation is the temptation to have AI do the coding for you. Even if the AI is learning from older code, that code probably still works, and the temptation to copy past without understanding the foundation can be problematic. You are not going to learn or grow if you do not understand. This feels like a personal issue though.

I have been through several technical interviews. I believe I am a good developer. Have a solid foundation. I can begin writing code without any help and understand how to lay out a project from the start. I understand the git operations, can write node scripts, have a solid understanding o object oriented programming like javascript or ruby. The technical interview scares the fool out of me though and have failed everyone I have ever taken. For various reasons. Many I did not understand the objective or went at it in a way that was not proper. Many times I simply did not understand. There is no way one who is copy pasting answers from AI can pass a technical interview. If I am wrong in this assumption, I will immediately stop doing things the hard way.