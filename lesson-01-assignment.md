# Week two Assignments

## Introduction

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

### Question 1:
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

Skip this step. There is no need to grab the students here, we can loop through them later to find the specific student we need. Originally I thought I needed a collection of students. I do, but they are already in a collection, no need to make my own special one.

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

stews is a collection, but grabbing a student using the specific enroll.student_id as an array works, but not great. It is the reason 1 needed to be subtracted to get the correct email, because array start at 0. Again probably not the best idea.

```ruby
spring_enrolls.each do |enroll|
  a = enroll.student_id
  entry = "student id: #{a}, student email: #{stews[a - 1].email}"
  email_list << entry
end
```

Instead of grabbing all students before, do it here, using _find_ method. Now I can use the newly found "student" for the template. The above works, but more because of the order of things in the tables. "_stews[a-1].email_" just happens to line up with the filtered "_spring_enrolls_" content. In the below snippet I am finding the student from the filtered collection, so the order in the table does not matter. Now that I think on it, the above is is still finding the correct student, but the concept is sound. The above is not proper and is problematic as it only works if things are just so. The below is more Rails convention and is not restricted to the box.

```ruby
spring_enrolls.each do |enroll|
  student = Student.find(enroll.student_id)
  entry = "student id: #{student.id}, student email: #{student.email}"
  email_list << entry
end
```

Print the emails

```ruby
email_list.each do |email|
  puts email
end
```

There are no safety checks here. Put the ```begin``` ```rescue``` back at a minimum. Conditionals like if statement checks. For example, what if nothing gets put in the email_list. What if there is nothing in spring_enrolls?

### Question Two:

For the second task we need to find all the mentors who have not assigned a final grade for the spring trimester and email them to remind them to finish grading.

Like Question one, we want to find any two mentors and provide a template with the ```<mentor id>, <mentor email>``` for the reminder.

mentor_enrollment_assignments, enrollments, courses, coding_classes, trimesters, mentors are up for review in completing this question.

**How many do not have a grade?** In the Enrollment table we have the course_id, student_id, and the final_grade. We are still looking at the spring trimester, so I can use the set up in question 1 to see how many have no grade.

```ruby
itp_id = CodingClass.find_by(title: "Intro to Programming").id
spring_id = Trimester.find_by(year: "2025", term: "Spring").id
spring_core_id = Course.where(coding_class_id: itp_id, trimester_id: spring_id).ids[0]
```

```ruby
needs_grades = Enrollment.where(course_id: spring_core_id).where(final_grade: nil)
```

This assumes that no grade is nil for the final grade. The first enrollment record has a final grade of "completed". The above returned 3 records. Are there other descriptors other than "completed", like "working", etc? Should those be considered in this list? 

Now that I have this list, need to find the associated mentors.

The mentor enrollment assignments table has both the mentor id and the enrollment id. Like with students, let's loop through the _needs_grades_ variable, using the enrollment id to find the mentor id from the mentor enrollment assignment model, then use that mentor id to get the mentor email from the mentor model? This will work but feels like there is a better way.

## Mindset Assignment

1. What's the rule of thumb for when to ask for help?

  Everyone is different. I prefer to do the research. I often find that sitting on it a day may produce the process for finding the answer I am looking for, but not always. This also takes time that most find unacceptable. I think the 20 min to half hour rule works fine. If you have hit the problem from the angles and have nothing, then ask for help. Before asking for help, be sure you understand the question, not the result or error that is staring back at you. Many of my solutions have came from my understanding of the questions I needed to answer, not so much beating the error I was getting to death.

2. When is an instance where you wish you would have asked for help sooner?

  I had created a blog for my portfolio. Loved it and I ran across a site for a service that was Rails focused, wish I could remember the site, That had a table of contents in it's blog. Immediately I knew I needed that in my life. I found a few articles that looked at it, and one video, but nothing I tried was a solid solution. What was truly frustrating was getting it complete, and it still not working. I wrote two stack overflow articles trying to get guidance. The first one did provide help, the second one never did. I kept the code but turned it off. Forgot about it for 5 to 6 months. Then one day while cleaning up a mess, I happened upon it and decided to test a concept as to why it did not work. The test provided a working concept for the table of contents with a minor change to the structure. I truly wish there had been a quicker way to have got help with this.

3. What information have you found crucial to include in your questions so that mentors or peers can help answer your questions quicker?

  Two things are a must here. One, take the time to explain your question, (refer to 1). There is a problem and you have tried to find a solution. In searching for a solution, you are hunting for the answer to your question. Explain your question. Many times your are not asking the right question, which means you do not understand the problem. Understanding the question is the first half of finding the solution. This is a concept I had a hard time with for a long time. The error that shows up could very well not be the problem. The error is a by product of the problem. You are asking the wrong question. Second is the logic, or code, you are focused on. Show what you are working with. To help with a solution one needs to be able to create the issue. It could be a syntax problem. It could be a logic problem. It could be any number of things. The point is, no one can help if they can't also see the problem. Be complete in your inquiry for help. Be specific. Taking the time in the ask will help with getting help.
