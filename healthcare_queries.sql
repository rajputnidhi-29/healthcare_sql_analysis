create database HealthcareDB;
use healthcareDB;
CREATE TABLE Patients
(PatientID INT  AUTO_INCREMENT PRIMARY KEY,
FullName VARCHAR(100) NOT NULL,
Age INT NOT NULL,
Gender VARCHAR(10) NOT NULL,
Address VARCHAR(255)
);
CREATE TABLE Hospitals(
HospitalID INT AUTO_INCREMENT Primary Key, 
HospitalName VARCHAR(100) NOT NULL,
Location VARCHAR(100) NOT NULL,
Capacity INT NOT NULL
);


CREATE TABLE Admissions(
AdmissionID INT  AUTO_INCREMENT Primary Key ,
PatientID INT,
HospitalID INT ,
 AdmissionDate DATE NOT NULL,
 DischargeDate DATE,
 ReasonForAdmission VARCHAR(255),
 Foreign Key (PatientID ) REFERENCES Patients(PatientID),
 Foreign Key(HospitalID) REFERENCES Hospitals(HospitalID)
 );
 CREATE TABLE Treatments(
 TreatmentID INT AUTO_INCREMENT PRIMARY KEY,
 AdmissionID INT,
 ProcedureName VARCHAR(100) NOT NULL,
 Cost Decimal(10,2) NOT NULL,
 Outcome VARCHAR(50),
 FOREIGN KEY (AdmissionID) REFERENCES Admissions(AdmissionID)
 );
 -- Insert data into Patients table
 INSERT INTO Patients (FullName, Age, Gender, Address) VALUES
('John Doe', 45, 'Male', '123 Elm Street'),
('Jane Smith', 34, 'Female', '456 Oak Avenue'),
('Sam Brown', 29, 'Male', '789 Pine Road'),
('Lisa White', 52, 'Female', '321 Maple Lane'),
('Tom Green', 67, 'Male', '654 Birch Blvd'),
('Alice Johnson', 40, 'Female', '987 Willow Court'),
('Robert Black', 60, 'Male', '564 Cypress Road'),
('Emily Davis', 25, 'Female', '321 Cedar Avenue'),
('Michael Scott', 50, 'Male', '742 Birch Lane'),
('Sarah Taylor', 33, 'Female', '159 Spruce Drive');

-- Insert data into Hospitals table
INSERT INTO Hospitals (HospitalName, Location, Capacity) VALUES
('General Hospital', 'New York', 500),
('City Clinic', 'Los Angeles', 200),
('Central Medical Center', 'Chicago', 300),
('Regional Health Facility', 'Houston', 150),
('Sunrise Hospital', 'Phoenix', 400);
-- Insert data into Admissions table
INSERT INTO Admissions (PatientID, HospitalID, AdmissionDate, DischargeDate, ReasonForAdmission) VALUES
(1, 1, '2024-11-01', '2024-11-05', 'Surgery'),
(2, 2, '2024-11-03', '2024-11-08', 'Therapy'),
(3, 3, '2024-11-10', '2024-11-15', 'Accident'),
(4, 4, '2024-11-12', '2024-11-19', 'Routine Checkup'),
(5, 5, '2024-12-01', '2024-12-08', 'Infection'),
(6, 1, '2024-12-01', NULL, 'Surgery'),
(7, 2, '2024-12-02', '2024-12-05', 'Fracture Repair'),
(8, 3, '2024-12-03', NULL, 'Chronic Illness'),
(9, 4, '2024-12-03', '2024-12-18', 'Therapy'),
(10, 5, '2024-12-04', '2024-12-18', 'Infection');
-- Insert data into Treatments table
INSERT INTO Treatments (AdmissionID, ProcedureName, Cost, Outcome) VALUES
(1, 'Appendectomy', 1500.00, 'Successful'),
(2, 'Physical Therapy', 800.00, 'Ongoing'),
(3, 'Fracture Repair', 3000.00, 'Successful'),
(4, 'Blood Test', 200.00, 'Pending'),
(5, 'Antibiotics', 500.00, 'Improved'),
(6, 'Gallbladder Surgery', 4000.00, 'Successful'),
(7, 'X-Ray', 300.00, 'Successful'),
(8, 'Chemotherapy', 5000.00, 'Ongoing'),
(9, 'MRI Scan', 1200.00, 'Pending'),
(10, 'Diabetes Treatment', 700.00, 'Improved');
-- Patient Demographics
SELECT
    Gender,
    COUNT(*) AS Number_of_Patients,
    AVG(Age) AS Average_Age
FROM Patients
GROUP BY Gender;
-- Hospital Utilization
select HospitalName, count(*) as Admission_number
from hospitals h  
join Admissions a 
on h.HospitalID=a.HospitalID
group by h.hospitalID;
 -- Treatment Costs
select 
h.hospitalID,h.HospitalName,sum(t.cost) as Total_revenue
from  Hospitals h 
join Admissions a 
on a.HospitalId=h.HospitalId
join Treatments t 
on a.AdmissionID=t.AdmissionID 
group by 
h.HospitalId ,h.HospitalID
order by Total_revenue desc;
 -- Length of Stay Analysis
select h.HospitalName,h.HospitalID,avg(datediff(a.DischargeDate,a.AdmissionDate)) as Length_Stay
from Hospitals h
join Admissions a 
on a.HospitalID=h.HospitalID
group by h.HospitalId, h.HospitalName;



-- Advanced Filtering
select *from patients 
where PatientID in(select PatientID from admissions
where datediff(DischargeDate,Admissiondate)>7);

select procedurename,count(*)
from treatments
group by procedurename
having count(*)>5;
 -- Combining Data 
 select * from admissions a 
left join treatments t 
on t.AdmissionID=a.AdmissionID ; 
 select reasonForAdmission ,a.patientiD,p.FullName,p.age,p.gender,p.address,
 row_number()over (partition by ReasonforAdmission
 order by reasonforadmission) as number
from admissions a 
join patients p 
on p.patientId=a.patientID;

-- Subqueries and Views 
select * from hospitals  
 where hospitalid =(
  select a.hospitalID 
  from admissions a
  join treatments t 
  on a.admissionID=t.admissionID 
group by a.hospitalid
order by avg(t.cost) desc
limit 1) ; 
create view HospitalPerformance as 
select h.hospitalid,h.hospitalname,count(a.admissionid) as total_count,
avg(datediff(a.dischargedate,a.admissiondate)) as length_of_stay,
sum(t.cost) as total_revenue
from hospitals h 
join admissions a 
on h.hospitalid=a.hospitalid
join treatments t 
on t.admissionid=a.admissionid
group by h.hospitalid,h.hospitalname;
select * from hospitalperformance;
-- Window Functions 
select h.hospitalid,h.hospitalname,sum(t.cost),
rank() over(  order by sum(t.cost) desc) as hospital_rank
 from hospitals h 
join admissions a
on h.hospitalid=a.hospitalid
join treatments t 
on t.admissionid=a.admissionid
group by h.hospitalid,h.hospitalname;

select procedurename,count(*),
dense_rank() over (
order by count(*) desc) as Treatment_rank 
from treatments
group by procedurename;
