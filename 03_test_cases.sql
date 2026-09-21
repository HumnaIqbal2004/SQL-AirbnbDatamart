SELECT
	CONCAT(u.First_name, ' ', u.Last_name) AS Guest_Name,
    b.Booking_id,
    p.Status AS Payment_Status
FROM GUESTS g JOIN USERS u ON g.User_id = u.User_id
JOIN BOOKINGS b ON g.Guest_id = b.Guest_id
JOIN PAYMENTS p ON b.Booking_id = p.Booking_id;

SELECT 
	CONCAT(u.First_name, ' ', u.Last_name) AS Guest_Name,
    pr.Title AS Property_Title,
    pr.Property_id,
    b.Booking_id
FROM BOOKINGS b
JOIN GUESTS g ON b.Guest_id = g.Guest_id
JOIN USERS u ON g.User_id = u.user_id
JOIN PROPERTIES pr ON b.Property_id = pr.Property_id;