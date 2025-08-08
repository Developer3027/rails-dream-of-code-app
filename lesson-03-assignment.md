# Week three assignment

## Lesson 3 Add lesson topics and the ability to associate lessons with topics

_NOTE_ This table created by KJ Loving. In her slide deck CRUD Associations. Kinda Awesome.

|  Association  |  Type  |  Description  |  Foreign Key Location  |  Used When ...  |
|  ---  |  ---  |  --- |  ---  |  ---  |
|  Belongs_to  |  One-to-One  |  Child points to its parent  | On the model with **belongs_to**  |  A record references another (e.g. **Comment** belongs_to **Post** )  |
|  has_one  |  one-to-one  |  Parent has one related child  |  On the associated (child) model  |  A model is expected to have exactly one related record (e.g., User has_one Profile)  |
|  has_many  | one-to-many  |  Parent has many children  |  On the associated (child) model  |  A model can have multiple related records (e.g., Author has_many Books)  |
|  has_one :through  |  one-to-one  |  One record is accessed _through_ another associated model  |  Uses intermediate model  |  To reach a related object via a middle model (e.g., Supplier -> Company -> Account)  |
|  has_many :through  |  many-to-many  |  Many records are accessed through a join model with its own logic or data  |  Join model stores foreign keys  |  Need a join model with extra data (e.g., Doctor has many Patients through Appointments)  |
|  has_and_belongs_to_many  |  many-to-many  |  Direct many-to-many without join model logic  |  Join table only, no model class  |  You need a quick many-to-many, with no extra info (e.g., Assembly and Part)  |

Dream of Code would like to add tags to course lessons so that a student can easily search for all DoC lessons on a certain topic, regardless of what course the lessons come from. Of course, a topic will have many lessons, and there will certainly be lessons that span many topics. So the relationship between topics and lessons will be "many-to-many", which means we'll need a join table, in addition to a new topics table.

Need to store these topic titles:
* SQL
* Data Modeling
* Javascript
* CSS
* Automated Testing
* Debugging
* Web Request Cycle
* HTTP

1. What tables do you need to add? Decide on table names and their associations to each other and any existing tables/models.
  * topics table for the topics.
  * topic_lessons join table.
  * _NOTE_: Rails will change plural and singular. You create the table "submissions" but the model is "submission" and in the rails model association and console you will use "submission". For this join table it is "topic_lessons" not "topics_lessons". The model will be "topic_lesson".
2. What columns are necessary for the associations you decided on?
  * Topics table needs topic_name column.
    * topic model assc - ```has_many :topic_lesson```, ```has_many :lessons, through: :topic_lesson```
  * Lesson model needs update
    * ```has_many :topic_lesson```, ```has_many :topics, through: :topic_lesson```
  * Topic_lesson needs references to both topic and lesson (t.reference, foreign_key).
    * ```belongs_to :topic```, ```belongs_to :lesson```
    * _NOTE_ The join table will reference another table. What does it "belong_to". These associations will give you helpers for looking up information easier.
3. What other columns (if any) need to be included on the tables? What other data needs to be stored?
  * If wanted we could associate the courses?
4. Write out each table's name and column names with data types.
  * Topics
    * topic_name :string
  * Topic_Lesson = table migration create_topic_lessons
    * topic :reference
    * lesson :reference
5. Determine the generator command you'll need to create the migration file and run the command to generate the empty migration file.
  * bin/rails g migration create_topics
  * bin/rails g migration create_topic_lessons
6. Inside the ```create_table``` block in the migration file, add the appropriate columns and data types.
  * t.string :topic - for topic table
  * t.reference :topic, foreign_key: false - for join - possible null: false?
  * t.reference :lesson, foreign_key: false - for join - possible null: false?
7. Run the migration with bin/rails db:migrate. Watch the output and make sure it is successful before moving on.
8. Add the ```Topic``` model before moving on.
9. Now determine the generator command you'll need to create the migration file for the join table. Don't forget that it should begin with ```create_``` and be followed by the table name.
  * bin/rails g migration create_topic_lessons
10. Inside the ```create_table``` block, add associations to topics and lessons with ```t.references :topic``` and ```t.references :lesson```
11. Run the migration.
12. If migration run was successful, create the model for your join table.
13. Open the console and test your new models by creating the topics above and adding them to some lessons.
  * Gather a few lessons using where
    * lessons = Lesson.where(id:[1,3,5])
  * Create topic and assc. Use "pluck" ruby method to grab id from lessons array
    * Topic.create(topic_name: "CSS", lesson_ids: lessons.pluck(:id))
  * Create singular topic and assc.
    * Topic.create!(topic_name: "HTTP", lesson_ids: 5)

## Mindset
**Motivation and Mindset**

* Why do you want to be a software developer?
  * I have always been a blue collar class. Always good with my hands. Have been an automotive tech for decades. I want to show my children what study and hard work gets. They are good kids, young and still so innocent. They grumble at choirs and do the minimum for school work. The money I make is not great and my wife is struggling even with a masters. I have three tweenagers living in a two bedroom apartment. They deserve more. My case is not special or unique. I will do what I can though so they don't look back on me thinking I was worthless. I need to give them more.
* What do you plan to do with your skills after the class ends?
  * My goal has always been to help, and make a living doing that. Whether that is on my own, I have some great ideas, or that is with a company that is willing to teach me, not that many jr dev jobs in a long time. I hope to be useful. To be needed and recognized for the contribution I make. Either way I will continue to follow these dreams of apps and hope to get them far enough so that one day, maybe my kids can use them in a meaningful way.
* Can you think of a time when a growth mindset helped you learn or achieve something new?
  * About a year ago I started thinking about how a table of contents would work in a rails blog. I tried a tutorial I found with no luck and moved on. There were not that many tutorials around for such and I figured I was not ready. Six to Seven months ago, probably a little longer than that, I tried again and asked for help on StackOverflow. I did get some help there but still was not in a place I could understand the help I got. Then I asked DeepSeek for help, around the time everyone found out that we were paying to much for AI development. This really helped me move forward with the service instead of having the model do it all like StackOverflow suggested. Everything went wonderfully and with much testing and back and forth I finally got it to work. Everything worked great and I was over the moon until I looked at the browser. The TOC was not being displayed in the browser. My heart sank. I put it back in the box and forgot about it until I ran across it here recently, when I was working on a separate sub project within it. That is when it occurred to me that I never tested the output from a different column in the table. I quickly created a new column in the blog table and directed the save to it, not back to the action text table. This did the trick! I finally had the id attributes in the h1 tags and the TOC was working as intended!
* What other mindsets have helped you learn new skills?
  * As I have grown older, I have been dealing with Cervical Dystonia. I get shots in the neck to help lesson the tremors. Due to VA issues I have not had any this year yet and my head shake can be a distraction for some, most. At work I have found that I can use humor to help set customers more at ease when talking with them. My head shakes as though I am saying no. I am not of course, but others do not know this. They just see me walking up to greet them shaking no, like they have done something wrong. I tell them my head shakes from a condition I have, or I am the most negative person they will ever meet. You are given these challenges in your life, these cards to hold and play. It is really your move when it comes to your life I think. Yes I get frustrated and depressed, but who doesn't. Like I said earlier, I am neither special or unique. I choose to walk the path beside the freeway. I am in no hurry.


