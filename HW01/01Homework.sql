\qecho Leonille Matunan
\qecho
\qecho #1
\qecho
/* Building room_number for all Rooms in the system. ( Note room_number not roomnum) */
SELECT
    building,
    roomNum AS room_number
FROM
    room
ORDER BY
    room_number,
    building;

\qecho 
\qecho #2
\qecho 
/* building room_number capacity For all rooms with capacity between 10 through 15 inclusive */
SELECT
    building,
    roomNum,
    capacity
FROM
    room
WHERE
    capacity BETWEEN 10 AND 15;

\qecho 
\qecho #3
\qecho 
/* attendees For the DB Issues meeting ( By attendees I mean the name of the Employee) Order by attendee */
SELECT
    employee.name AS attendees
FROM
    attendees
    JOIN meeting ON attendees.meetingid = meeting.id
    JOIN employee ON attendees.employeeid = employee.id
WHERE
    meeting.purpose = 'DB Issues'
ORDER BY
    employee.name;

\qecho 
\qecho #4
\qecho 
/* Starttime duration purpose for all of Winston’s meetings ( Where Winston is the creator of the
meeting) */
SELECT
    meeting.starttime,
    meeting.duration,
    meeting.purpose
FROM
    meeting
    JOIN employee ON meeting.creator = employee.id
WHERE
    employee.name = 'Winston'
ORDER BY
    starttime;

\qecho 
\qecho #5
\qecho 
/* Starttime duration purpose building roomnum for all meetings Alice is attending. */
SELECT
    meeting.starttime,
    meeting.duration,
    meeting.purpose,
    room.building,
    room.roomnum
FROM
    meeting
    JOIN attendees ON meeting.id = attendees.meetingid
    JOIN employee ON attendees.employeeid = employee.id
    JOIN room ON meeting.roomid = room.id
WHERE
    employee.name = 'Alice'
ORDER BY
    purpose DESC,
    starttime;

\qecho 
\qecho #6
\qecho 
/* name phone For all employees. */
SELECT
    name,
    phone
FROM
    employee
ORDER BY
    name ASC;

\qecho 
\qecho #7
\qecho 
/* creator_name purpose building room_number meetingreason, starttime, duration for all meetings
owned by Alice ( Note custom column names ) Sort by starttime ( most recent date at top)*/
SELECT
    employee.name AS creator_name,
    meeting.purpose,
    room.building,
    room.roomNum AS room_number,
    meeting.purpose AS meetingreason,
    meeting.starttime,
    meeting.duration
FROM
    meeting
    JOIN employee ON meeting.creator = employee.id
    JOIN room ON meeting.roomid = room.id
WHERE
    employee.name = 'Alice'
ORDER BY
    starttime DESC;

\qecho 
\qecho #8
\qecho 
/* dept_name emp_name purpose building roomnum for all meetings in every department that starts with ‘Software’ where the meeting is in building ‘B’ Sort by dept_name, emp_name, purpose */
SELECT DISTINCT
    department.name AS dept_name,
    employee.name AS emp_name,
    meeting.purpose,
    room.building,
    room.roomnum
FROM
    employee
    JOIN department ON employee.departmentID = department.id
    JOIN attendees ON employee.id = attendees.employeeid
    JOIN meeting ON meeting.id = attendees.meetingid
    JOIN room ON meeting.roomid = room.id
WHERE
    department.name LIKE 'Software%'
    AND room.building = 'B';

\qecho 
\qecho #9
\qecho 
/* creator_name homephone for every meeting creator
order by creator_name ( Note – based on what we have talked about in class, you will have to present multiple lines for each creator. If you want to read ahead and present only one line per creator, feel free to have
fun) */
SELECT DISTINCT
    employee.name AS creator_name,
    employee.homephone AS homephone
FROM
    employee
    JOIN meeting ON meeting.creator = employee.id
ORDER BY
    creator_name;

\qecho 
\qecho #10
\qecho 
/* building roomnumber starttime for every meeting. order by start time, roomnum */
SELECT
    room.building,
    room.roomnum,
    meeting.starttime
FROM
    room
    JOIN meeting ON room.id = meeting.roomid
ORDER BY
    starttime;

