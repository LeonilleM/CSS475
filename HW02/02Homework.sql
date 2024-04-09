\qecho Leonille Matunan
\qecho
\qecho #1
\qecho
/* Find the number of meetings in each building – ordered by building ( A before B) Column names: building num_meetings */
SELECT
    room.building,
    COUNT(*) AS num_meetings
FROM
    meeting
    JOIN room ON meeting.roomid = room.id
GROUP BY
    room.building
ORDER BY
    room.building;

\qecho
\qecho #2
\qecho
/* Return the number of meetings in each room in each building order by building, roomNumber Column names: building roomNumber nummeetings*/
SELECT
    room.building,
    room.roomnumber,
    COUNT(*) AS nummeetings
FROM
    room
    JOIN meeting ON meeting.roomid = room.id
GROUP BY
    room.roomnumber,
    room.building
ORDER BY
    room.building,
    room.roomnumber;

\qecho
\qecho #3
\qecho
/* Similar to #2 Omit any room with less than 2 meetings */
SELECT
    room.building,
    room.roomnumber,
    COUNT(*) AS nummeetings
FROM
    room
    JOIN meeting ON meeting.roomid = room.id
GROUP BY
    room.roomnumber,
    room.building
HAVING
    COUNT(*) >= 2
ORDER BY
    nummeetings;

\qecho
\qecho #4
\qecho
/* Find the number of attendees in each meeting. Order by starttime, purpose Column names purpose, starttime, num_attendees */
SELECT
    meeting.purpose,
    meeting.starttime,
    COUNT(*) AS num_attendees
FROM
    meeting
    JOIN attendees ON meeting.id = attendees.meetingid
GROUP BY
    meeting.id,
    meeting.purpose,
    meeting.starttime
ORDER BY
    meeting.starttime,
    meeting.purpose;

\qecho
\qecho #5
\qecho
/* Find the number of available seats in each meeting. Order by available seats_available Ascending, starttime Column names: purpose starttime num_attendees, seats_available */
SELECT
    meeting.purpose,
    meeting.starttime,
    COUNT(*),
    room.capacity - COUNT(*) AS seats_available
FROM
    Meeting
    JOIN attendees ON meeting.id = attendees.meetingid
    JOIN room ON meeting.roomid = room.Id
GROUP BY
    meeting.id,
    meeting.purpose,
    meeting.starttime,
    room.capacity
ORDER BY
    seats_available,
    meeting.starttime;

\qecho
\qecho #6
\qecho
/* Find the moderator and type of meeting. List the combination of Moderator and Type only once. Order by employeeNum Column names: employeenum moderator purpose */
SELECT DISTINCT
    employee.employeeNum,
    employee.name AS moderator,
    meeting.purpose
FROM
    employee
    JOIN meeting ON employee.id = meeting.moderatorid
ORDER BY
    employee.employeeNum,
    moderator;

\qecho
\qecho #7
\qecho
/* We want to know how many meetings each creator has created. Order by employeeNum Columns names ‘Employee Name’, ‘NumCreated’, */
SELECT
    employee.name AS "Employee Name",
    COUNT(*) AS "Num Created"
FROM
    employee
    JOIN meeting ON employee.id = meeting.creatorId
GROUP BY
    employee.id,
    meeting.creatorid
ORDER BY
    employee.employeeNum;

\qecho
\qecho #8
\qecho
/* Find the total number of meetings each moderator is moderating. Order by moderatorid Column names ModeratorName, NumMeetings */
SELECT
    employee.name AS Moderator,
    COUNT(*) AS nummeetings
FROM
    employee
    JOIN meeting ON employee.id = meeting.moderatorId
GROUP BY
    employee.id,
    meeting.moderatorId
ORDER BY
    Moderator;

\qecho
\qecho #9
\qecho
/* Find number of meetings attended by each employee */
SELECT
    employee.employeeNum,
    employee.name,
    COUNT(*)
FROM
    employee
    JOIN attendees ON employee.id = attendees.employeeid
GROUP BY
    attendees.employeeid,
    employee.employeeNum,
    employee.name
ORDER BY
    employee.employeeNum;

\qecho
\qecho #10
\qecho
/* Find time of meetings by each employee ( add duration ) */
SELECT
    employee.employeeNum,
    employee.name,
    SUM(meeting.duration) AS totalduration
FROM
    employee
    JOIN attendees ON employee.id = attendees.employeeid
    JOIN meeting ON attendees.meetingid = meeting.id
GROUP BY
    employee.employeeNum,
    employee.name
ORDER BY
    employee.employeeNum;

\qecho #11
\qecho
/* Create a list giving the count of phone numbers under each category ( Cell, Pager, etc) Order by category Column names: category, count */
SELECT
    phonetype.name AS category,
    COUNT(*)
FROM
    phonetype
    JOIN phone ON phonetype.id = phone.phonetypeid
GROUP BY
    phonetype.name
ORDER BY
    category;

\qecho
\qecho #12
\qecho
/* The ‘Lunch’ meeting scheduled for 2018-03-28 12:00:00 has been canceled. Create a list of all attendees to the meeting and give the cell phone number for each. Order by name Column name: attendee cell_number*/
SELECT
    employee.name AS attendee,
    phone.number AS cell_number
FROM
    employee
    JOIN phone ON employee.id = phone.employeeid
        AND phone.phonetypeid = 'C'
    JOIN attendees ON employee.id = attendees.employeeid
    JOIN meeting ON attendees.meetingid = meeting.id
WHERE
    meeting.purpose = 'Lunch'
    AND meeting.starttime = '2018-03-28 12:00:00'
ORDER BY
    attendee,
    cell_number;

\qecho
\qecho #13
\qecho
/* Same as prior except provide emails order by email Column name attendee email*/
SELECT
    employee.name AS attendee,
    employee.email
FROM
    employee
    JOIN attendees ON employee.id = attendees.employeeid
    JOIN meeting ON attendees.meetingid = meeting.id
WHERE
    meeting.purpose = 'Lunch'
    AND meeting.starttime = '2018-03-28 12:00:00'
ORDER BY
    attendee,
    email;

\qecho
\qecho #14
\qecho
/* Provide a list of the total salaries in each department Order by department name Column names: name numEmployees totalSalary*/
SELECT
    department.name,
    COUNT(*) AS "numEmployees",
    SUM(employee.salary) AS "totalSalary"
FROM
    department
    JOIN employee ON department.id = employee.departmentid
GROUP BY
    department.name
ORDER BY
    department.name;

