\qecho Leonille



-- 1- Find the total number of meetings for each department ( IE a meeting is in a department if any
-- members of the department are attendees in the meeting)
-- Column Names: dept_id, num_meetings
-- Order by dept_id
-- Note – this query will be very useful in problem #10
\qecho
\qecho #1
\qecho 
SELECT 
    department.id as dept_id,
    COUNT(DISTINCT meeting.id) as num_meetings
FROM department
    JOIN employee ON department.id = employee.departmentID
    JOIN attendees ON employee.id = attendees.employeeID
    JOIN meeting ON attendees.meetingID = meeting.id
GROUP BY 
    department.id
ORDER BY 
    department.id;

-- 2 – We want to find ( for every creator of a meeting) The total number of attendees for their meetings,
-- The total capacity of the rooms for all of the meetings that they have booked, and the number of
-- available, empty seats in those rooms.
-- Column Names: name, attendees, capacity, availseats
-- Order By creatorid, availseats
\qecho
\qecho #2
\qecho
SELECT 
    name,
    COUNT(DISTINCT attendees.employeeID) as attendees,
    SUM(DISTINCT room.capacity) as capacity,
    SUM(DISTINCT room.capacity) - SUM(DISTINCT attendees.employeeID) as availseats
FROM employee
    JOIN meeting ON employee.id = meeting.creatorID
    JOIN attendees ON meeting.id = attendees.meetingID
    JOIN room ON meeting.roomID = room.id
GROUP BY
    name,
    employee.id
ORDER BY
    employee.id,
    SUM(DISTINCT room.capacity) - SUM(DISTINCT attendees.employeeID);

-- 3 – Find the name of the employee who is attending the most meetings, and the number of meetings
-- they are signed up for. Compute a number ( “compute .75” ) which is 75% of the total number of
-- meetings for that person.
-- Column Names: name , numMeetings, compute.75
-- 4 – Find all employees who are attending almost as many meetings as the most prolific meeting
-- attender. ‘almost as many’ is defined as attending 75% of the number of meetings the most prolific
-- meetening attender attends.
-- Column Names: name, numMeetings
-- Order by numMeetings, name; Put highest number of meetings at the top (Dave)
-- NOTE – do not hard code the value you are comparing to. Assume my DB has different values
-- from yours.
-- 5 – Find the average room utilization for all meetings occurring on 2018-03-04 at 10:00 AM . Express
-- the utilization as a percentage value which is ‘total number of rooms with meeting’ / ‘total number of
-- rooms’
-- Column Names: Util in %
-- 6 – Find the number of employees we have for each phone type. ( Cell, Home etc)
-- Column Names: category, num_employees
-- Order By :category
-- 7 – Find the number of phone listings we have for each phone type ( Cell, Home, etc)
-- Column Names: category, num_listings
-- Order By category
-- Note – the difference between #6 and #7 is that if an employee has 2 phone numbers of
-- The same type – under 6 it would increase the count by 1. In #7 it would increase the count by
-- 2
-- 8 – Find the number of cell phones in each meeting that takes place in building B
-- Column Names: meetingid, purpose, num_cell_phones
-- Order By meetingid
-- 9 – Find the average number of cell phones for all meetings in building B Display answer to two decimal
-- places ( assume employees always have cell phones with them)
-- Column Names: avg_phones
-- 10 – Find the average time spent by employees in meeting for each department
-- Column Names: department_name, avg_time
-- Order By purpose, department_name
-- Note - #10 Hint I solved this with two sub-selects ( one to give you the total duration by department
-- and one to give you number of meetings per department) One of those sub selects will have a sub-
-- select embedded within it