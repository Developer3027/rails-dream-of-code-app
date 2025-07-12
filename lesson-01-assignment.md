# Lesson One

In this lesson we went through a introduction to data in Rails. We set up the rails environment on our local, forked the CTD repo, followed instructions in the repo readme to seed data for a SQLite database, then searched through the data in various tables to collect information to use.

For context in answering the assignment questions, in the Rails console, we found the id for the fall trimester and used it to search through all the coding classes for the fall. We returned the title for those classes.

```ruby
upcoming_courses = Course.where(trimester: 7)

upcoming_courses.each do |course|
  puts course.coding_class.title
end
```

In the above example, "_upcoming_courses_" is the variable we put the search into. _Course_ is the class model for the table that has the data. _where_ is a SQL method that will return all records found that match what is passed in. _trimester: 7_ is the condition we are looking for. We need all the courses for the fall semester, (id: 7), easily accessible in a bucket called _upcoming_courses_. We then loop through those with the _.each_ method and return the course title.

_**NOTE**: Copy the following code snippets into rails console (terminal) in order._ 

## Question 1:
**Finish Task 1: Collect emails for students in the current intro course.**

We are looking for any two students enrolled in the "Intro to Programming" class for the Spring of 2025. We need to return the template <student_id>, <student_email>.

* Get id for "intro to programming" class
```ruby
itp_id = CodingClass.find_by(title: "Intro to Programming").id
```
* Find id for trimesters
```ruby
spring_id = Trimester.find_by(year: "2025", term: "Spring").id
```

* Get course id for "intro to programming", spring trimester.

Probably should use _find_ or _find_by_ here. The collection return a single record. Grabbing the index for ids [0] of the collection.
```ruby
spring_core_id = Course.where(coding_class_id: itp_id, trimester_id: spring_id).ids[0]
```

* Filter enrollment

The initial _spring_enrolls_ collection had a _student_id = 0_. Adjusted collection to filter out that student as well.
```ruby
spring_enrolls = Enrollment.where(course_id: spring_core_id).where('student_id != 0')
```

* Grab students

Grab all students. Use this later for email. Remember the index may not be equal to the student id. Verify.
```ruby
stews = Student.all
```

* Create empty array

Empty array to put template into.
```ruby
email_list = []
```

* Loop through filtered enrollment, creating a template, put template in array.

_( << ):_  called shovel operator, adds template to end of array.

Probably better to use _map_ here instead of _each_ as map will not change the original spring_enrolls collection.
```ruby
spring_enrolls.each do |enroll|
  a = enroll.student_id
  entry = "student id: #{a}, student email: #{stews[a - 1].email}"
  email_list << entry
end
```
