CREATE DATABASE airbnb_datamart;
USE airbnb_datamart;

CREATE TABLE USERS (
	User_id INT auto_increment primary key,
    	First_name VARCHAR(50) NOT NULL,
    	Last_name VARCHAR(50) NOT NULL,
    	Email VARCHAR(150) NOT NULL UNIQUE,
    	Phone_No VARCHAR(20) NOT NULL,
    	Password VARCHAR(255) NOT NULL,
    	Role VARCHAR(10) NOT NULL,
    	User_Rating DECIMAL(3,2) DEFAULT NULL,
    	CONSTRAINT chk_user_rating CHECK (User_rating IS NULL OR (User_rating >= 1.00 	AND User_rating <=5.00))
    );

CREATE TABLE EMPLOYEES (
    Employee_id INT AUTO_INCREMENT PRIMARY KEY,                 
    First_name VARCHAR(50) NOT NULL,                            
    Last_name VARCHAR(50) NOT NULL,                             
    Email VARCHAR(150) NOT NULL UNIQUE,                         
    Phone_No VARCHAR(20) NOT NULL,                              
    Hired_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,       
    Role VARCHAR(50) NOT NULL                                   
);

CREATE TABLE ADMINISTRATORS (
    Admin_id INT AUTO_INCREMENT PRIMARY KEY,                    
    Employee_id INT NOT NULL UNIQUE,                            
    Admin_level VARCHAR(100) NOT NULL,                          
    FOREIGN KEY (Employee_id) REFERENCES EMPLOYEES(Employee_id) ON DELETE CASCADE
);

CREATE TABLE GUESTS (
	Guest_id INT auto_increment PRIMARY KEY,
   	User_id INT NOT NULL UNIQUE,
    	Preferred_Payment VARCHAR(50) NOT NULL,
   	Billing_Address VARCHAR(250) NOT NULL,
    	FOREIGN KEY (User_id) REFERENCES USERS(User_id) ON DELETE CASCADE);

CREATE TABLE GUEST_VERIFICATION (
    GVerification_id INT AUTO_INCREMENT PRIMARY KEY,            
    Guest_id INT NOT NULL,                                      
    Admin_id INT NOT NULL,                                      
    Identification_Document_No VARCHAR(100) NOT NULL,           
    Status VARCHAR(50) NOT NULL,                                
    Verified_at DATETIME DEFAULT NULL,                          
    FOREIGN KEY (Guest_id) REFERENCES GUESTS(Guest_id) ON DELETE CASCADE,
    FOREIGN KEY (Admin_id) REFERENCES ADMINISTRATORS(Admin_id) ON DELETE CASCADE
);



CREATE TABLE HOSTS (
    Host_id INT AUTO_INCREMENT PRIMARY KEY,                    
    User_id INT NOT NULL UNIQUE,                               
    Payout_method VARCHAR(100) NOT NULL,                        
    Available_properties INT DEFAULT 0,                         
    FOREIGN KEY (User_id) REFERENCES USERS(User_id) ON DELETE CASCADE
);

CREATE TABLE HOST_VERIFICATION (
    HVerification_id INT AUTO_INCREMENT PRIMARY KEY,            
    Host_id INT NOT NULL,                                       
    Admin_id INT NOT NULL,                                      
    Identification_Document_No VARCHAR(100) NOT NULL,           
    Status VARCHAR(50) NOT NULL,                                
    Verified_at DATETIME DEFAULT NULL,                          
    FOREIGN KEY (Host_id) REFERENCES HOSTS(Host_id) ON DELETE CASCADE,
    FOREIGN KEY (Admin_id) REFERENCES ADMINISTRATORS(Admin_id) ON DELETE CASCADE
);


CREATE TABLE CUSTOMER_SUPPORTS (
    CustomerSup_id INT AUTO_INCREMENT PRIMARY KEY,               
    Employee_id INT NOT NULL UNIQUE,                            
    Tickets_resolved INT DEFAULT 0,                             
    Language VARCHAR(100) NOT NULL,                             
    FOREIGN KEY (Employee_id) REFERENCES EMPLOYEES(Employee_id) ON DELETE CASCADE
);

CREATE TABLE PROPERTIES (
    Property_id INT AUTO_INCREMENT PRIMARY KEY,                 
    Host_id INT NOT NULL,                                       
    Title VARCHAR(100) NOT NULL,                                
    Description VARCHAR(250) NOT NULL,                          
    Price INT NOT NULL,                                         
    Address VARCHAR(250) NOT NULL,                              
    City VARCHAR(100) NOT NULL,                                 
    State VARCHAR(100) NOT NULL,                                
    Country VARCHAR(100) NOT NULL,                             
    Postal_Code VARCHAR(20) NOT NULL,                           
    Max_Guests INT NOT NULL,                                    
    Available BOOLEAN DEFAULT TRUE,                             
    Listed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,     
    FOREIGN KEY (Host_id) REFERENCES HOSTS(Host_id) ON DELETE CASCADE
);

CREATE TABLE AMENITIES (
    Amenity_id INT AUTO_INCREMENT PRIMARY KEY,                   
    Amenity_name VARCHAR(100) NOT NULL UNIQUE                   
);

CREATE TABLE AMENITY_LISTING (
    Amenity_Listing_id INT AUTO_INCREMENT PRIMARY KEY,           
    Amenity_id INT NOT NULL,                                    
    Property_id INT NOT NULL,                                   
    FOREIGN KEY (Amenity_id) REFERENCES AMENITIES(Amenity_id) ON DELETE CASCADE,
    FOREIGN KEY (Property_id) REFERENCES PROPERTIES(Property_id) ON DELETE CASCADE
);



CREATE TABLE PHOTOS (
    Photo_id INT AUTO_INCREMENT PRIMARY KEY,                    
    Property_id INT NOT NULL,                                   
    URL VARCHAR(500) NOT NULL,                                  
    FOREIGN KEY (Property_id) REFERENCES PROPERTIES(Property_id) ON DELETE CASCADE
);

CREATE TABLE BOOKINGS (
    Booking_id INT AUTO_INCREMENT PRIMARY KEY,                  
    Property_id INT NOT NULL,                                   
    Guest_id INT NOT NULL,                                      
    Check_in_date DATETIME NOT NULL,                            
    Check_out_date DATETIME NOT NULL,                           
    Guests_count INT NOT NULL,                                  
    Status VARCHAR(50) NOT NULL,                                
    Booked_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,      
    FOREIGN KEY (Property_id) REFERENCES PROPERTIES(Property_id) ON DELETE CASCADE,
    FOREIGN KEY (Guest_id) REFERENCES GUESTS(Guest_id) ON DELETE CASCADE
);

CREATE TABLE PAYMENTS (
    Payment_id INT AUTO_INCREMENT PRIMARY KEY,                  
    Booking_id INT NOT NULL,                                    
    Guest_id INT NOT NULL,                                      
    Amount DECIMAL(10,2) NOT NULL,                              
    Currency VARCHAR(50) NOT NULL DEFAULT 'EURO',                
    Status VARCHAR(50) NOT NULL,                                
    FOREIGN KEY (Booking_id) REFERENCES BOOKINGS(Booking_id) ON DELETE CASCADE,
    FOREIGN KEY (Guest_id) REFERENCES GUESTS(Guest_id) ON DELETE CASCADE
);

CREATE TABLE PAYOUTS (
    Payout_id INT AUTO_INCREMENT PRIMARY KEY,                   
    Payment_id INT NOT NULL,                                    
    Host_id INT NOT NULL,                                       
    Status VARCHAR(50) NOT NULL,                                
    FOREIGN KEY (Payment_id) REFERENCES PAYMENTS(Payment_id) ON DELETE CASCADE,
    FOREIGN KEY (Host_id) REFERENCES HOSTS(Host_id) ON DELETE CASCADE
);

CREATE TABLE CANCELLATIONS (
    Cancellation_id INT AUTO_INCREMENT PRIMARY KEY,             
    Booking_id INT NOT NULL,                                    
    Guest_id INT NOT NULL,                                      
    Status VARCHAR(50) NOT NULL,                                
    Cancelled_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,   
    FOREIGN KEY (Booking_id) REFERENCES BOOKINGS(Booking_id) ON DELETE CASCADE,
    FOREIGN KEY (Guest_id) REFERENCES GUESTS(Guest_id) ON DELETE CASCADE
);

CREATE TABLE REFUNDS (
    Refund_id INT AUTO_INCREMENT PRIMARY KEY,                   
    Payment_id INT NOT NULL,                                    
    Cancellation_id INT NOT NULL,                               
    CustomerSup_id INT DEFAULT NULL,                            
    Status VARCHAR(50) NOT NULL,                                
    FOREIGN KEY (Payment_id) REFERENCES PAYMENTS(Payment_id) ON DELETE CASCADE,
    FOREIGN KEY (Cancellation_id) REFERENCES CANCELLATIONS(Cancellation_id) ON DELETE CASCADE,
    FOREIGN KEY (CustomerSup_id) REFERENCES CUSTOMER_SUPPORTS(CustomerSup_id) ON DELETE SET NULL
);


CREATE TABLE COMPLAINT_TICKETS (
    Complaint_id INT AUTO_INCREMENT PRIMARY KEY,                
    User_id INT NOT NULL,                                       
    Booking_id INT DEFAULT NULL,                                
    Property_id INT DEFAULT NULL,                               
    Against_User_id INT DEFAULT NULL,                           
    CustomerSup_id INT DEFAULT NULL,                            
    Subject VARCHAR(250) NOT NULL,                              
    Body TEXT NOT NULL,                                         
    Status VARCHAR(20) NOT NULL,                                
    Created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,     
    FOREIGN KEY (User_id) REFERENCES USERS(User_id) ON DELETE CASCADE,
    FOREIGN KEY (Booking_id) REFERENCES BOOKINGS(Booking_id) ON DELETE SET NULL,
    FOREIGN KEY (Property_id) REFERENCES PROPERTIES(Property_id) ON DELETE SET NULL,
    FOREIGN KEY (Against_User_id) REFERENCES USERS(User_id) ON DELETE SET NULL,
    FOREIGN KEY (CustomerSup_id) REFERENCES CUSTOMER_SUPPORTS(CustomerSup_id) ON DELETE SET NULL
);


CREATE TABLE REVIEWS (
    Review_id INT AUTO_INCREMENT PRIMARY KEY,                   
    Reviewer_user_id INT NOT NULL,                              
    Reviewee_user_id INT NOT NULL,                              
    Property_id INT NOT NULL,                                   
    Rating INT NOT NULL,                                        
    Comments TEXT,                                              
    Created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,     
    FOREIGN KEY (Reviewer_user_id) REFERENCES USERS(User_id) ON DELETE CASCADE,
    FOREIGN KEY (Reviewee_user_id) REFERENCES USERS(User_id) ON DELETE CASCADE,
    FOREIGN KEY (Property_id) REFERENCES PROPERTIES(Property_id) ON DELETE CASCADE,
    CONSTRAINT chk_review_rating CHECK (Rating >= 1 AND Rating <= 5)
);


CREATE TABLE MESSAGES (
    Message_id INT AUTO_INCREMENT PRIMARY KEY,                  
    Sender_user_id INT NOT NULL,                                
    Receiver_user_id INT NOT NULL,                              
    Body TEXT NOT NULL,                                         
    Sent_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,        
    FOREIGN KEY (Sender_user_id) REFERENCES USERS(User_id) ON DELETE CASCADE,
    FOREIGN KEY (Receiver_user_id) REFERENCES USERS(User_id) ON DELETE CASCADE
);




