ALTER SEQUENCE Employee_id_seq
    RESTART WITH 101;

ALTER SEQUENCE phone_id_seq
    RESTART WITH 101;

BEGIN;
\qecho Leonille Matunan
/* 1 - Find the total number of meetings for each department ( IE a meeting is in a department if any
members of the department are attendees in the meeting)
Column Names: dept_id, num_meetings
Order by dept_id */
\qecho
\qecho #1
\qecho
SELECT
    department.id AS "dept_id",
    COUNT(DISTINCT meeting.id) AS "num_meetings"
FROM
    department
    JOIN employee ON department.id = employee.departmentid
    JOIN attendees ON employee.id = attendees.employeeid
    JOIN meeting ON attendees.meetingid = meeting.id
GROUP BY
    department.id
ORDER BY
    department.id;

/* 2 – We want to find ( for every creator of a meeting) The total number of attendees for their meetings,
The total capacity of the rooms for all of the meetings that they have booked, and the number of
available, empty seats in those rooms.
Column Names: name, attendees, capacity, availseats
Order By creatorid, availseats */
\qecho
\qecho #2
\qecho
SELECT
    employee.id,
    employee.name,
    SUM(Table1.total_attendees) AS "attendees",
    SUM(room.capacity) AS "capacity",
    SUM(room.capacity - total_attendees) AS "availseats"
FROM
    Employee
    JOIN meeting ON employee.id = meeting.creatorid
    JOIN room ON meeting.roomid = room.id
    JOIN (
        SELECT
            meeting.id AS meetingID,
            COUNT(attendees.employeeid) AS "total_attendees",
            creatorID
        FROM
            meeting
            JOIN attendees ON meeting.id = attendees.meetingid
        GROUP BY
            meeting.id,
            creatorID) AS Table1 ON meeting.id = Table1.meetingID
GROUP BY
    employee.id,
    employee.name
ORDER BY
    "availseats" ASC;

/* 3 – Find the name of the employee who is attending the most meetings, and the number of meetings
they are signed up for. Compute a number ( “compute .75” ) which is 75% of the total number of
meetings for that person.
Column Names: name , numMeetings, compute.75 */
\qecho
\qecho #3
\qecho
SELECT
    name,
    numMeetings,
    numMeetings * 0.75 AS "75Percent"
FROM (
    SELECT
        name,
        COUNT(attendees.meetingid) AS numMeetings
    FROM
        employee
        JOIN attendees ON employee.id = attendees.employeeid
    GROUP BY
        employee.id,
        name
    ORDER BY
        COUNT(attendees.meetingid) DESC
    LIMIT 1) AS subquery_alias;

/* 4 – Find all employees who are attending almost as many meetings as the most prolific meeting
attender. ‘almost as many’ is defined as attending 75% of the number of meetings the most prolific
meetening attender attends.
Column Names: name, numMeetings
Order by numMeetings, name; Put highest number of meetings at the top (Dave)
NOTE – do not hard code the value you are comparing to. Assume my DB has different values
from yours. */
\qecho
\qecho #4
\qecho
SELECT
    name,
    numMeetings
FROM (
    SELECT
        name,
        COUNT(attendees.meetingid) AS numMeetings
    FROM
        employee
        JOIN attendees ON employee.id = attendees.employeeid
    GROUP BY
        employee.id,
        name
    HAVING
        COUNT(attendees.meetingid) >=(
            SELECT
                COUNT(attendees.meetingid) * 0.75
            FROM
                employee
                JOIN attendees ON employee.id = attendees.employeeid
            GROUP BY
                employee.id
            ORDER BY
                COUNT(attendees.meetingid) DESC
            LIMIT 1)
    ORDER BY
        COUNT(attendees.meetingid) DESC,
        name) AS subquery_alias;

/* 5 – Find the average room utilization for all meetings occurring on 2018-03-04 at 10:00 AM . Express
the utilization as a percentage value which is ‘total number of rooms with meeting’ / ‘total number of
rooms’
Column Names: Util in % */
\qecho
\qecho #5
\qecho
SELECT
    COUNT(DISTINCT meeting.roomid) * 100.0 / COUNT(DISTINCT room.id) AS "Util in %"
FROM (
    SELECT
        room.id
    FROM
        room
        JOIN meeting ON room.id = meeting.roomid
    WHERE
        meeting.starttime = '2018-03-04 10:00:00' AS subquery_alias);

/* 6 – Find the number of employees we have for each phone type. ( Cell, Home etc)
Column Names: category, num_employees
Order By :category
 */
\qecho
\qecho #6
\qecho
/* b7 – Find the number of phone listings we have for each phone type ( Cell, Home, etc)
Column Names: category, num_listings
Order By category
Note – the difference between #6 and #7 is that if an employee has 2 phone numbers of
The same type – under 6 it would increase the count by 1. In #7 it would increase the count by 2 */
\qecho
\qecho #7
\qecho
/* 8 – Find the number of cell phones in each meeting that takes place in building B
Column Names: meetingid, purpose, num_cell_phones
Order By meetingid */
\qecho
\qecho #8
\qecho
/* 9 – Find the average number of cell phones for all meetings in building B Display answer to two decimal
places ( assume employees always have cell phones with them)
Column Names: avg_phones */
\qecho
\qecho #9
\qecho
/* 10 – Find the average time spent by employees in meeting for each department
Column Names: department_name, avg_time
Order By purpose, department_name */
\qecho
\qecho #10
\qecho
