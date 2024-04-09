\qecho Leonille
\qecho
\qecho #1
\qecho 
/* We want to see the start and end times for each meeting in building A Order by startTime, roomNumber Columns: building roomnumber */
SELECT
    room.building,
    room.roomnumber,
    meeting.startTime AS startdatetime,
    meeting.startTime + meeting.duration AS enddatetime
FROM
    meeting
    JOIN room ON meeting.roomid = room.id
WHERE
    room.building = 'A'
ORDER BY
    meeting.startTime,
    room.roomnumber;

\qecho
\qecho #2
\qecho 
/* We want to see information about every meeting in the system. Order by startTime and roomNumber Columns: roomNumber startDate, startTime, endTime*/
SELECT
    room.building,
    room.roomnumber,
    DATE(meeting.startTime) AS startDate,
    meeting.startTime::time AS startTime,
    meeting.startTime::time + meeting.duration AS endTime
FROM
    room
    JOIN meeting ON meeting.roomid = room.id
ORDER BY
    meeting.startTime,
    room.roomnumber;

\qecho
\qecho #3
\qecho 
/*  Show the capacity of each room If there is no capacity noted – print “unknown’ as the value. Order by building + roomNumber Columns building, roomNumber, numseats*/
SELECT
    room.building,
    room.roomNumber,
    COALESCE(CAST(capacity AS varchar), 'unknown') AS numseats
FROM
    room
ORDER BY
    room.building,
    room.roomNumber;

\qecho
\qecho #4
\qecho
/* How many rooms in each building have capacity noted? Order by Building Columns Building, RoomsWithCapacity */
SELECT
    room.building,
    COUNT(*) AS RoomsWithCapacity
FROM
    room
WHERE
    room.capacity > 0
GROUP BY
    room.building
ORDER BY
    room.building;

\qecho
\qecho #5
\qecho 
/* Find the total number of seats in all rooms in all buildings Columns “Total Seat Count”*/
SELECT
    SUM(room.capacity) AS "Total Seat Count"
FROM
    room;

\qecho
\qecho #6
\qecho 
/*Assume that if there is no capacity noted – the capacity is 100 Given that assumption find the total number of seats in all buildings Columns “Total Seat Count” */
SELECT
    SUM(COALESCE(room.capacity, 100)) AS "Total Seat Count"
FROM
    room;

\qecho
\qecho #7
\qecho 
/* Find all meetings starting between 10:30 AM and 2:00 PM Order by meeting.id Columns purpose, startdate, starttime*/
SELECT
    meeting.purpose,
    DATE(meeting.starttime) AS startdate,
    meeting.starttime::time AS starttime
FROM
    meeting
WHERE
    meeting.starttime::time BETWEEN '10:30:00' AND '14:00:00'
ORDER BY
    meeting.id;

\qecho
\qecho #8
\qecho 
/*  What meetings will be occurring after 4:00 PM? Order by meeting.id Colulmns purpose time duration*/
SELECT
    meeting.purpose,
    meeting.starttime::time AS time,
    meeting.duration
FROM
    meeting
WHERE
    meeting.starttime::time <= '16:00'
    AND meeting.starttime::time + meeting.duration > '16:00'
ORDER BY
    meeting.id;

\qecho
\qecho #9
\qecho 
/* List all meetings that are happening on 2018-03-28 at 2:30 PM Columns purpose, starttime, duration*/
SELECT
    meeting.purpose,
    meeting.starttime,
    meeting.duration
FROM
    meeting
WHERE
    DATE(meeting.starttime) = '2018-03-28'
    AND meeting.starttime::time <= '14:30:00'
    AND meeting.starttime::time + meeting.duration > '14:30:00';

\qecho
\qecho #10
\qecho 
/* we want to understand which meeting purposes do not have a moderator. ( show purpose only once) order by purpose Column names purpose*/
SELECT DISTINCT
    meeting.purpose
FROM
    meeting
WHERE
    meeting.moderatorid IS NULL
ORDER BY
    meeting.purpose;

\qecho
\qecho #11
\qecho 
/*We want to know which employees are in meetings on 2018-03-18 at 10:00 Show each employee only once. Column names : employeenum, name*/
SELECT DISTINCT
    employee.employeeNum,
    employee.name
FROM
    employee
    JOIN attendees ON employee.id = attendees.employeeid
    JOIN meeting ON attendees.meetingid = meeting.id
WHERE
    DATE(meeting.starttime) = '2018-03-18'
    AND meeting.starttime::time <= '10:00:00'
    AND meeting.starttime::time + meeting.duration > '10:00:00';

\qecho
\qecho #12
\qecho 
/* Find all employees who are double booked at 2018-03-18 at 10:00 Order by EmployeeNum Columns names: employeenum, ‘numDouble’ ( where numDouble are the num meetings )*/
SELECT
    employeeNum,
    COUNT(attendees.meetingid) AS numDouble
FROM
    employee
    JOIN attendees ON employee.id = attendees.employeeid
    JOIN meeting ON attendees.meetingid = meeting.id
WHERE
    DATE(meeting.starttime) = '2018-03-18'
GROUP BY
    employeeNum
HAVING
    COUNT(attendees.meetingid) > 1
ORDER BY
    employeeNum;

\qecho
\qecho #13
\qecho 
/* Which employee spends the most times attending meetings which have a moderator? Columns employeenum, name, ‘totalDuration’*/
SELECT
    employeeNum,
    name,
    SUM(meeting.duration) AS totalDuration
FROM
    Employee
    JOIN attendees ON employee.id = attendees.employeeid
    JOIN meeting ON attendees.meetingid = meeting.id
WHERE
    meeting.moderatorid IS NOT NULL
GROUP BY
    employeeNum,
    name
ORDER BY
    totalDuration DESC
LIMIT 1;

\qecho
\qecho #14
\qecho 
/* We want to find out the average salary cost by meeting purpose ( IE how much money are all these meetings costing the company IE what is the average salary for Lunch meetings vs Staff meetings etc) Order by purpose Column names: purpose, ‘Average Salary’*/
SELECT
    meeting.purpose,
    AVG(employee.salary) AS "Average Salary"
FROM
    meeting
    JOIN attendees ON meeting.id = attendees.meetingid
    JOIN employee ON attendees.employeeid = employee.id
WHERE
    meeting.purpose = 'DB Issues'
GROUP BY
    meeting.purpose;

