/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

select * from Facilities where membercost > 0.0


/* Q2: How many facilities do not charge a fee to members? */

select * FROM Facilities WHERE membercost = 0.0


/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */


SELECT facid, name, membercost, monthlymaintenance from Facilities where (membercost < (monthlymaintenance/(select sum(monthlymaintenance) from Facilities)*20)/100)

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

select * FROM Facilities WHERE facid IN(1, 5)

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

select name, monthlymaintenance,
CASE WHEN monthlymaintenance > 100 THEN 'expensive'
	 ELSE 'cheap' END AS label
from Facilities

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

select firstname, surname FROM Members

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */


select members.firstname as name, facilities.name
from Members as members
JOIN Bookings as bookings ON members.memid = bookings.memid
JOIN Facilities as facilities ON facilities.facid = bookings.facid
WHERE facilities.name like 'Tenni%' ORDER BY members.firstname



/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */


select CONCAT(members.firstname,facilities.name), facilities.guestcost
from Members as members
JOIN Bookings as bookings ON members.memid = bookings.memid
JOIN Facilities as facilities ON facilities.facid = bookings.facid
WHERE (facilities.guestcost > 30) AND ((CAST(starttime as date) > '2012-09-13 00:00:00')  AND (CAST(starttime as date) < '2012-09-15 00:00:00'))


/* Q9: This time, produce the same result as in Q8, but using a subquery. */


select CONCAT(members.firstname,facilities.name), facilities.guestcost
from Members as members
JOIN Bookings as bookings ON members.memid = bookings.memid
JOIN Facilities as facilities ON facilities.facid = bookings.facid
WHERE (facilities.guestcost > 30) AND bookings.starttime IN (select starttime from Bookings where (CAST(starttime as date) > '2012-09-13 00:00:00')  AND (CAST(starttime as date) < '2012-09-15 00:00:00'))


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */


SELECT name, 
	guestcost + membercost + initialoutlay + monthlymaintenance AS 'total_revenue'
	from Facilities 
where guestcost + membercost + initialoutlay + monthlymaintenance < 1000 ORDER BY total_revenue




