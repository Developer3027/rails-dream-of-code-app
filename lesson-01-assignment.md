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

## Question 1:
**Finish Task 1: Collect emails for students in the current intro course.**

We are looking for any two students enrolled in the "Intro to Programming" class for the Spring of 2025. We need to return the template <student_id>, <student email>.

* Get id for "intro to programming" class
```ruby
itp_id = CodingClass.find_by(title: "Intro to Programming").id
```
* Find id for trimesters
```ruby
fall_id = Trimester.find_by(year: "2025", term: "Fall").id
spring_id = Trimester.find_by(year: "2025", term: "Spring").id
```

* Get course id for "intro to programming", spring and fall trimester.
```ruby
fall_core_id = Course.where(coding_class_id: itp_id, trimester_id: fall_id).ids[0]
spring_core_id = Course.where(coding_class_id: itp_id, trimester_id: spring_id).ids[0]
```

* Filter enrollment
```ruby
fall_enrolls = Enrollment.where(course_id: fall_core_id)
spring_enrolls = Enrollment.where(course_id: spring_core_id)
```

* Grab students
```ruby
stews = Student.all
```

* Create empty array
```ruby
email_list = []
```

* Loop through filtered enrollment, creating a template, put template in array.
```ruby
spring_enrolls.each do |enroll|
  entry = "student id: #{enroll.student_id}, student email: #{stews[enroll.student_id].email}"
  email_list.push(entry)
end
```
