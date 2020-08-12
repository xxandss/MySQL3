# 1.查询同时存在1课程和2课程的情况
select    a.studentId, a.courseID,a.score,b.name  student_name,b.age,b.sex,c.name  course_name,c.teacherId,d.name  teacher_name
  from  ( ( select t1.studentId, t1.courseId,t1.score 
             from (select * from student_course where courseId=1)  t1  ,
		          (select * from student_course where courseId=2)  t2
					where  t1.studentId = t2.studentId )   
		    union
		 ( select t2.studentId, t2.courseId,t2.score  
             from (select * from student_course where courseId=1)  t1  ,
		          (select * from student_course where courseId=2)  t2
					where  t1.studentId = t2.studentId )   
         )  a   
left join  student         b
	   on  a.studentId = b.id   
left join  course          c
       on  a.courseId = c.id
left join  teacher         d
       on  c.teacherId = d.id    ;
# 2.查询同时存在1课程和2课程的情况
select    a.studentId,b.name  student_name,b.age,b.sex
  from   ( select t1.studentId
             from (select * from student_course where courseId=1)  t1  ,
		          (select * from student_course where courseId=2)  t2
			where  t1.studentId = t2.studentId )   a   
left join  student         b
	   on  a.studentId = b.id   ;
# 3.查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩
select a.studentId , b.name student_name , a.avg_score
from  (select studentId , avg(score)  avg_score
      from student_course
	  group by studentId
      having avg(score)>60)  a ,
      student b
where a.studentId = b.id;
# 4.查询在student_course表中不存在成绩的学生信息的SQL语句
select *
  from student  
 where id not in (select studentId
                    from student_course
                   where score is not null) ;
# 5.查询所有有成绩的SQL
select *
from  student
where id in (select studentId from student_course where score is not null group by studentId );
# 6.查询学过编号为1并且也学过编号为2的课程的同学的信息
select *
  from student
 where id in (select  t1.studentId 
              from  student_course  t1
              left join student_course   t2
                     on t1.studentId = t2.studentId
			  where t1.courseId=1
               and  t2.courseId=2 );
# 7.检索1课程分数小于60，按分数降序排列的学生信息
select b.courseId, studentId, name,age,sex,b.score
from student a, 
     (select studentId,courseId,score from student_course where score< 60 and courseId= 1)  b
where a.id = b.studentId
order by b.score  desc  ;
# 8.查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列
select b.courseID ,a.name course_name, avg(score)
from  course a ,
      student_course b
where a.id = b.courseId
group by courseId
order by avg(score) desc ,courseId asc;
# 9.查询课程名称为"数学"，且分数低于60的学生姓名和分数
select  b.name  course_name ,a.name   student_name , b.score
  from  student   a ,
       (select t1.studentID,t2.name,t1.score
		  from student_course  t1,
			   course          t2
		 where t1.score < 60
           and t1.courseId=t2.id
           and t2.name='数学') b 
 where a.id = b.studentId  ;
