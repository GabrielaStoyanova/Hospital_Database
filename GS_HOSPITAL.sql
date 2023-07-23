DROP DATABASE GS_HOSPITAL;
CREATE DATABASE GS_HOSPITAL;
USE GS_HOSPITAL;

CREATE TABLE patient(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL,
egn VARCHAR(10) NOT NULL UNIQUE,
address VARCHAR(255) NOT NULL,
diagnosis VARCHAR(255) NOT NULL,
gender ENUM('Female','Male','Other'),
age INT NOT NULL
);

ALTER TABLE patient
ADD CONSTRAINT EGN CHECK (char_length(egn) = 10);

CREATE TABLE bill(
id INT AUTO_INCREMENT PRIMARY KEY,
patientID INT NULL,  
CONSTRAINT FOREIGN KEY (patientID) REFERENCES patient(id),
priceMeds DOUBLE NOT NULL,
priceRep DOUBLE NOT NULL,
paid boolean default 0
);

ALTER TABLE bill
DROP FOREIGN KEY bill_ibfk_1;
ALTER TABLE bill
ADD CONSTRAINT FOREIGN KEY patientID_key (patientID) references patient(id)
ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE doctor(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL,
room INT NOT NULL,
phone VARCHAR(20) NULL DEFAULT NULL,
email VARCHAR(50) NULL DEFAULT NULL,
healthFund boolean default 0,
type ENUM('Permanent','Trainee','Visiting'),
specialization ENUM('Family medicine','Internal Medicine','Pediatrician', 'Obstetricians/gynecologist (OBGYNs)', 
'Cardiologist', 'Oncologist', 'Gastroenterologist', 'Pulmonologist', 'Infectious disease', 'Nephrologist', 
'Endocrinologist', 'Ophthalmologist', 'Otolaryngologist', 'Dermatologist', 'Psychiatrist', 'Neurologist', 'Radiologist',
'Anesthesiologist', 'Surgeon', 'Physician executive')
);

CREATE TABLE patient_doctor(
patientID INT NOT NULL,  
CONSTRAINT FOREIGN KEY (patientID) REFERENCES patient(id),
doctorID INT NOT NULL,
CONSTRAINT FOREIGN KEY (doctorID) REFERENCES doctor(id),
PRIMARY KEY(patientID, doctorID)
);

ALTER TABLE patient_doctor 
DROP FOREIGN KEY patient_doctor_ibfk_2;
ALTER TABLE patient_doctor
ADD CONSTRAINT FOREIGN KEY doctorID_key (doctorID) references doctor(id)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE patient_doctor 
DROP FOREIGN KEY patient_doctor_ibfk_1;
ALTER TABLE patient_doctor
ADD CONSTRAINT FOREIGN KEY patientID_key (patientID) references patient(id)
ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE medicalReport(
id INT AUTO_INCREMENT PRIMARY KEY,
patientID INT NULL UNIQUE,  
CONSTRAINT FOREIGN KEY (patientID) REFERENCES patient(id),
doctorID INT NULL,
CONSTRAINT FOREIGN KEY (doctorID) REFERENCES doctor(id),
dateOfMaking DATE NULL DEFAULT NULL
);

ALTER TABLE medicalReport
DROP FOREIGN KEY medicalreport_ibfk_1;
ALTER TABLE medicalReport
ADD CONSTRAINT FOREIGN KEY patientID_key (patientID) references patient(id)
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE medicalReport
DROP FOREIGN KEY medicalreport_ibfk_2;
ALTER TABLE medicalReport
ADD CONSTRAINT FOREIGN KEY doctorID_key (doctorID) references doctor(id)
ON DELETE SET NULL ON UPDATE CASCADE;

/* ALTER TABLE medicalReport auto_increment=27;*/ /*Reset the auto increment directly*/

CREATE TABLE medicines(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL,
quantity VARCHAR(255) NOT NULL
);

CREATE TABLE rep_meds(
medID INT NOT NULL,  
CONSTRAINT FOREIGN KEY (medID) REFERENCES medicines(id),
repID INT NOT NULL,
CONSTRAINT FOREIGN KEY (repID) REFERENCES medicalReport(id),
PRIMARY KEY(medID, repID)
);

ALTER TABLE rep_meds
DROP FOREIGN KEY rep_meds_ibfk_2;
ALTER TABLE rep_meds
ADD CONSTRAINT FOREIGN KEY repID_key (repID) references medicalReport(id)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE rep_meds
DROP FOREIGN KEY rep_meds_ibfk_1;
ALTER TABLE rep_meds
ADD CONSTRAINT FOREIGN KEY medID_key (medID) references medicines(id)
ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE inpatient(
id INT AUTO_INCREMENT PRIMARY KEY,
repID INT NULL UNIQUE,
CONSTRAINT FOREIGN KEY (repID) REFERENCES medicalReport(id),
roomID INT NULL,
CONSTRAINT FOREIGN KEY (roomID) REFERENCES room(id),
dateOfAdmission DATE NOT NULL,
dateOfDischarge DATE NOT NULL,
daysOfStaying INT NULL DEFAULT NULL
);

ALTER TABLE inpatient
DROP FOREIGN KEY inpatient_ibfk_3;
ALTER TABLE inpatient
ADD CONSTRAINT FOREIGN KEY repID_key (repID) references medicalReport(id)
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE inpatient
DROP FOREIGN KEY inpatient_ibfk_4;
ALTER TABLE inpatient
ADD CONSTRAINT FOREIGN KEY roomID_key (roomID) references room(id)
ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE room(
id INT AUTO_INCREMENT PRIMARY KEY,
type VARCHAR(255) NOT NULL,
status ENUM('Occupied','Dirty','Clean', 'Vacant')
);

CREATE TABLE outpatient(
id INT AUTO_INCREMENT PRIMARY KEY,
repID INT NULL UNIQUE,
CONSTRAINT FOREIGN KEY (repID) REFERENCES medicalReport(id),
daysOfTreatment INT NOT NULL
);

ALTER TABLE outpatient
DROP FOREIGN KEY outpatient_ibfk_1;
ALTER TABLE outpatient
ADD CONSTRAINT FOREIGN KEY repID_key (repID) references medicalReport(id)
ON DELETE SET NULL ON UPDATE CASCADE;

/*For Dermatoligist*/
INSERT INTO patient (name, egn, address, diagnosis, gender, age) 
VALUES ('Ivana Petkova Stoyanova', '7509041245', 'Sofia, 72 Patriarh Evtimii Blvd.', 'Acne', 'Female', '35'),
('Georgi Ivanov Todorov', '8010091245', 'Varna, 1 Kajmakchalan Str.', 'Eczema', 'Male', '21'),
('Iliqn Todorov Georgiev', '8407106352', 'Sofia, 10 A Knqz Alexander Batenberg Str.', 'Rosacea', 'Male', '44');

/*For Family medicine*/
INSERT INTO patient (name, egn, address, diagnosis, gender, age) 
VALUES ('Maria Georgieva Todorova ', '8207104452', 'Sofia, 13 Hristo Botev blvd.', 'Cough', 'Female', '27'),
('Hannah Popova Dobreva', '8107103352', 'Plovdiv, 15 Dobrudja Str.', 'Fever', 'Female', '41'),
('Stoyan Minkov Petkov', '7707101352', 'Sofia, 24 Knjaz Dondukov Blvd.', 'Laryngitis', 'Male', '44');

/*For Pediatrician*/
INSERT INTO patient (name, egn, address, diagnosis, gender, age) 
VALUES ('Mariana Petkova Dobreva', '9207102452', 'Sofia, zk.Nadezhda 3', 'Well Child Check-up (<1 month)', 'Female', '31'),
('Yolanda Ivanova Ivanova', '9507103356', 'Vraca, 4 Skobelev Blvd.', 'Autism spectrum disorder', 'Female', '28'),
('Vanessa Davidkova Kazimuva', '9707102351', 'Sofia, Oborishte Str.', 'Learning disorder', 'Female', '26'),
('Gary Drakov Antov', '9107107358', 'Veliko Turnovo, 6 Breza Str.', 'Depression', 'Male', '32'),
('Brandon Walsh Makenzi', '9301107327', 'Lovech, 70 Vitosha Blv.', 'Overweight/obesity', 'Male', '30');

/*For Surgeon*/
INSERT INTO patient (name, egn, address, diagnosis, gender, age) 
VALUES ('Mariika Ivanova Ivanova', '8707101451', 'Sofia, zk.Nadezhda 1', 'Biopsy', 'Female', '36'),
('Victoria Jivkova Petrova', '9807103951', 'Blagoevgrad, 74 Evlogi Georgiev Blvd.', 'Remove diseased tissue', 'Female', '25'),
('Regina Stefanova Smolqnova', '9007102322', 'Sofia, zk. Hipodruma', 'Remove diseased organ', 'Female', '33'),
('Andrea Antova Ivanova', '9506105311', 'Sofia, 6 Breza Str.', 'Remove an obstruction', 'Female', '28'),
('Kevin Sivov Maznev', '9401109329', 'Sofia, 98 Ralevitca Str.', 'Improve physical appearance', 'Male', '29'),
('Mark Maznev Boqdjiev', '8801209232', 'Sofia, Neofit Rilski str.', 'Implant mechanical device', 'Male', '35'),
('John Boqdjiev Mitov', '8302062427', 'Sandanski, Mladost II', 'Implant electronic devices', 'Male', '40');

/*For Obstetricians/gynecologist (OBGYNs)*/
INSERT INTO patient (name, egn, address, diagnosis, gender, age) 
VALUES ('Beatrice Dobreva Garcheva', '0333099145', 'Sofia, zk.Svoboda 1', 'Delayed puberty', 'Female', '20'),
('Jessica Nistorova Nistorova', '0402103953', 'Sliven, 85 Evlogi Georgiev Str.', 'Eating disorder', 'Female', '19'),
('Katherine Plamenova Antonova', '0506602334', 'Sofia, 2 Futekov str.', 'STDs ', 'Female', '18'),
('Martha Trifonova Aleksandrova', '0136105387', 'Sofia, zh.Lulin 5', 'Pregnancy', 'Female', '22');

/*For Pulmonologist*/
INSERT INTO patient (name, egn, address, diagnosis, gender, age) 
VALUES ('Russell Georgiev Georgiev', '7107104157', 'Sofia, zh.Lulin 1', 'Spirometry', 'Male', '52'),
('Edward Topchiev Zhotev', '6307103377', 'Sofia, zh. Krasna Polqna', 'Bloodwork', 'Male', '60'),
('Nichola Radkov Radkov', '7607106655', 'Sofia, zh.Lulin 5', 'Chronic lung disease', 'Male', '47');

/*For Ophthalmologist*/
INSERT INTO patient (name, egn, address, diagnosis, gender, age) 
VALUES ('Hailey Kirova Georgieva', '8804104451', 'Sofia, St.Kriptian Str.', 'Symptoms of eye disease', 'Female', '35');

/*UPDATE patient
SET gender = 'Female'
WHERE id = 26; EXECUTED */

/*For Infectious disease*/
INSERT INTO patient (name, egn, address, diagnosis, gender, age) 
VALUES ('Natasha Smolqnova Zaharieva', '7707102153', 'Sofia, Mladost 3', 'Strep throat', 'Female', '46'),
('Christian Gargiev Mihailov', '6107103476', 'Sofia, 93 A Vasil Levski blvd.', 'AIDS', 'Male', '62'),
('Valerie Lilova Kadneva', '9507103915', 'Sofia, Bolgrad Str., Lozenets', 'Ringworm', 'Female', '28');

/*For Gastroenterologist*/
INSERT INTO patient (name, egn, address, diagnosis, gender, age) 
VALUES ('Daniel Ganov Stefanov', '7504103956', 'Sofia, zh.Manastirkski Livadi', 'Gastroesophageal reflux disease (GERD)', 'Male', '48');

/*For Endocrinologist*/
INSERT INTO patient (name, egn, address, diagnosis, gender, age) 
VALUES ('Mila Georgieva Peeva', '7104107852', 'Sliven, 85 Evlogi Georgiev Str.', 'Diabetes', 'Female', '52');

/*For Radiologist*/
INSERT INTO patient (name, egn, address, diagnosis, gender, age) 
VALUES ('Dylan Merliev Vedev', '7904106859', 'Dobrich, Patriarh Evtimii blvd.', 'Magnetic resonance imaging(MRI)', 'Male', '44');

/*For doctor table*/
INSERT INTO doctor (name, room, phone, email, healthFund, type, specialization) 
VALUES ('Minka Mineva Yordanova', '12', '0894254731' , 'Yordanova@gmail.com', '1', 'Permanent', 'Dermatologist'),
('Peter Stankov Todorov', '14', '0897754744' , 'Todorov@gmail.com', '0', 'Permanent', 'Internal Medicine'),
('Paolina Andreeva Lolova', '6', '0886754743' , 'Lolova@gmail.com', '1', 'Permanent', 'Family medicine'),
('Ivan Illiev Spasov', '3', '0876758749' , 'Spasov@gmail.com', '1', 'Permanent', 'Pediatrician'),
('Georgi Manolov Angelov', '23', '0887754773' , 'Angelov@gmail.com', '0', 'Visiting', 'Pediatrician'),
('Veneta Pancheva Petrunova', '21', '0897154743' , 'Petrunova@gmail.com', '1', 'Permanent', 'Obstetricians/gynecologist (OBGYNs)'),
('Ivailo Gurdev Kaloqnov', '24', '0897754761' , 'Kaloqnov@gmail.com', '0', 'Trainee', 'Obstetricians/gynecologist (OBGYNs)');

INSERT INTO doctor (name, room, phone, email, healthFund, type, specialization) 
VALUES ('Stoyan Marinov Malinov', '20', '' , '', '1', 'Permanent', 'Cardiologist'),
('Stiliyana Boqdjieva Romanova', '11', '' , '', '1', 'Permanent', 'Oncologist'),
('Kalina Miteva Vasileva', '9', '0891154777' , 'Vasileva@gmail.com', '1', 'Permanent', 'Pulmonologist'),
('Kalin Vutov Nankov', '7', '0881131775' , 'Nankov@gmail.com', '1', 'Permanent', 'Infectious disease');

INSERT INTO doctor (name, room, phone, email, healthFund, type, specialization) 
VALUES ('Alexandar Vladimirov Borislavov', '2', '0891131763' , 'Borislavov@gmail.com', '1', 'Permanent', 'Surgeon'),
('Galq Vencislavova Bobova', '1', '0891131763' , 'Bobova@gmail.com', '1', 'Visiting', 'Surgeon'),
('Luboslav Popov Nikolaev', '1', '0891131763' , 'Bobova@gmail.com', '0', 'Trainee', 'Surgeon');

/*For patient_doctor table*/
INSERT INTO patient_doctor (patientID, doctorID) 
VALUES ('1', '1'),
('2', '1'),
('3', '1');

INSERT INTO patient_doctor (patientID, doctorID) 
VALUES ('4', '3'),
('5', '3');

INSERT INTO patient_doctor (patientID, doctorID) 
VALUES ('7', '4'), ('8', '5'), ('9', '5'),('10', '4'), ('11', '4');

INSERT INTO patient_doctor (patientID, doctorID) 
VALUES ('21', '6'), ('22', '6'), ('19', '6');

INSERT INTO patient_doctor (patientID, doctorID) 
VALUES ('23', '10'), ('24', '10'), ('25', '10');

INSERT INTO patient_doctor (patientID, doctorID) 
VALUES ('27', '11'), ('28', '11'), ('29', '11');

INSERT INTO patient_doctor (patientID, doctorID) 
VALUES ('12', '12'), ('13', '12'), ('14', '12'),('15', '13'), ('16', '13'), ('17', '13'), ('18', '12');

/*For medicalReport table*/
INSERT INTO medicalReport (patientID, doctorID, dateOfMaking) 
VALUES ('1', '1', '2023-12-03'), ('2', '1', '2023-01-13'), ('3', '1', '2023-11-04');

INSERT INTO medicalReport (patientID, doctorID, dateOfMaking) 
VALUES ('4', '3', '2023-10-06'), ('5', '3', '2023-02-03'), ('7', '4', '2023-09-01'),
('10', '4', '2023-11-10'), ('11', '4', '2023-07-11'), ('8', '5', '2023-05-09'),
('9', '5', '2023-02-10'), ('21', '6', '2023-09-11'), ('22', '6', '2023-11-09'),
('19', '6', '2023-04-10'), ('23', '10', '2023-07-12'), ('24', '10', '2023-11-12'),
('25', '10', '2023-05-11'), ('27', '11', '2023-05-23'), ('28', '11', '2023-11-29'),
('29', '11', '2023-06-17'), ('12', '12', '2023-05-12'), ('13', '12', '2023-03-27'),
('14', '12', '2023-07-14'), ('15', '12', '2023-01-19'), ('16', '13', '2023-08-21'),
('17', '13', '2023-12-09'), ('18', '13', '2023-06-02');

/*For medicines table*/
INSERT INTO medicines (name, quantity) 
VALUES ('Lidocaine', '10'), ('Nitrous oxide', '12'), ('Paracetamol', '20'),
('Ibuprofen', '30'), ('Morphine', '25'), ('Methadone', '9'),
('Dexamethasone', '45'), ('Epinephrine (adrenaline)', '50'), ('Diazepam', '3'),
('Ivermectin', '60'), ('Chloramphenicol', '21');
 
/*For room table*/
INSERT INTO room (type, status) 
VALUES ('1 bed', 'Occupied'), ('3 beds', 'Dirty'), ('1 bed', 'Vacant'),
('3 beds', 'Vacant'), ('2 beds', 'Vacant'), ('3 beds', 'Vacant'),
 ('3 beds', 'Vacant'), ('3 beds', 'Vacant'), ('2 beds', 'Clean'),
 ('2 beds', 'Clean'), ('1 bed', 'Occupied'), ('2 beds', 'Vacant'),
 ('3 beds', 'Vacant'), ('3 bed', 'Occupied'), ('3 beds', 'Vacant'),
 ('3 beds', 'Vacant'),('3 beds', 'Vacant'),('3 beds', 'Vacant'),
 ('3 bed', 'Occupied'), ('3 beds', 'Dirty'), ('3 beds', 'Dirty'),
 ('3 beds', 'Clean'), ('2 beds', 'Clean'), ('2 beds', 'Occupied'),
 ('3 beds', 'Vacant'), ('2 bed', 'Vacant'), ('3 beds', 'Vacant');
 
/*For rep_meds table*/
INSERT INTO rep_meds (medID, repID) 
VALUES ('4', '1');

INSERT INTO rep_meds (medID, repID) 
VALUES ('4', '6'), ('4', '23'),
('3', '19'), ('3', '17'), ('3', '8'),
('4', '15'), ('7', '20'), ('7', '21'),
('10', '11'), ('10', '13'),('10', '16'),
('9', '15'), ('6', '26'), ('10', '8');

/*For bill table*/
TRUNCATE TABLE bill;
INSERT INTO bill (patientID, priceMeds, priceRep, paid) 
VALUES ('1', '20.00', '100.00', '1'), ('3', '10.00', '50.00', '0'), ('6', '100.00', '30.00', '0'),
('4', '10.00', '5.00', '1'), ('27', '15.00', '00.00', '1'), ('12', '135.00', '200.00', '1'),
('31', '5.00', '300.00', '0'), ('26', '500.00', '1000.00', '0'), ('29', '55.00', '50.00', '0'),
('11', '45.00', '25.00', '1'), ('2', '60.00', '00.00', '1'), ('28', '20.00', '100.00', '0'),
('7', '35.00', '15.00', '1'), ('22', '300.00', '1000.00', '0'), ('30', '300.00', '100.00', '1') ;

/*For outpatient table*/
INSERT INTO outpatient (repID, daysOfTreatment) 
VALUES ('1', '14'), ('2', '14'), ('3', '28'),
('4', '14'), ('5', '10'), ('26', '10'),
('6', '0'), ('9', '0'), ('10', '3'),
('7', '10'), ('8', '10'), ('11', '0'),
('13', '5'), ('15', '1');

/*For inpatient table*/
INSERT INTO inpatient (repID, roomID, dateOfAdmission, dateOfDischarge, daysOfStaying) 
VALUES ('16', '3', '2023-07-03', '2023-07-23', '20'), ('20', '26', '2023-03-10', '2023-03-13', '3'),
('21', '26', '2023-05-06', '2023-05-26', '20'), ('22', '12', '2023-04-21', '2023-05-15', '25'),
('24', '12', '2023-06-09', '2023-06-19', '10'), ('25', '15', '2023-01-01', '2023-01-11', '10'),
('23', '15', '2023-09-05', '2023-09-20', '15'), ('18', '16', '2023-02-05', '2023-02-10', '5');

/*SELECT with restraint*/
SELECT * 
FROM doctor 
WHERE healthFund=1;

SELECT name, room, phone, healthFund as WorkingWithHealthFund, type, specialization
FROM doctor 
WHERE healthFund=1 AND type= 'permanent';

SELECT name, room as RoomsOnFirstFloor, healthFund, type, specialization
FROM doctor 
WHERE room BETWEEN 1 AND 10;

SELECT name, egn, diagnosis
FROM patient 
WHERE name LIKE 'M%'; 

SELECT name, egn, diagnosis, gender
FROM patient 
WHERE gender='Male'; 

SELECT id, dateOfMaking
FROM medicalReport 
WHERE dateOfMaking BETWEEN '2023-07-01' AND '2023-07-31';

SELECT id, dateOfMaking
FROM medicalReport 
WHERE dateOfMaking >= '2023-10-01';

/*SELECT with aggregate function and GROUP BY*/
SELECT COUNT(patientID) as NumberOfPatients, doctorID 
FROM patient_doctor 
GROUP BY doctorID;

SELECT (SUM(priceMeds) + SUM(priceRep)) as GeneralPaymentAmount, COUNT(id) as NumberOfPatients, paid as PaidOrNot
FROM bill
GROUP BY paid;

SELECT MIN(priceMeds) as MinPriceOfMedicines, MIN(priceRep) as MinPriceOfReport,
MAX(priceMeds) as MaxPriceOfMedicines, MAX(priceRep) as MaxPriceOfReport, paid as PaidOrNot
FROM bill
GROUP BY paid;

SELECT COUNT(id) as NumberOfDoctors, specialization as TypeOfSpecialization
FROM doctor 
GROUP BY specialization;

SELECT COUNT(id) as NumberOfRooms, type as TypeOfRooms, status as StatusOfRooms
FROM room
GROUP BY status, type;  

SELECT COUNT(repID) as NumberOfPatients, roomID as NumberOfRoom
FROM inpatient
GROUP BY roomID;

SELECT COUNT(id) as NumberOfPatients, gender as GenderOfPatients, ROUND(AVG(age), 2) as AverageAgeOfPatients 
FROM patient
GROUP BY gender; 

/*INNER JOIN*/
SELECT patient.name as NameOfPatient, patient.egn as EgnOfPatient, patient.diagnosis as DiagnosisOfPatient, 
patient.gender as GenderOfPatient, patient.age as AgeOfPatient, doctor.name as NameOfDoctor, doctor.room RoomOfDoctor, 
doctor.phone as PhoneOfDoctor, doctor.healthFund, doctor.specialization as SpecializationOfDoctor
FROM patient JOIN doctor 
ON patient.id IN(SELECT patientID
FROM patient_doctor
WHERE patient_doctor.doctorID = doctor.id);

SELECT doctor.name as NameOfDoctor, doctor.specialization as SpecializationOfDoctor, 
patient.name as NameOfPatient, patient.diagnosis as DiagnosisOfPatient,
medicalReport.id as MedicalReportID, medicalReport.dateOfMaking
FROM patient JOIN doctor 
ON patient.id IN(SELECT patientID
FROM patient_doctor
WHERE patient_doctor.doctorID = doctor.id)
JOIN medicalReport
ON patient.id = patientID;

SELECT medicalReport.id as MedicalReportID, medicalReport.dateOfMaking as MedicalReport_DateOfMaking, 
outpatient.id as OutpatientID, outpatient.daysOfTreatment as OutpatientDaysOfTreatment
FROM medicalReport JOIN outpatient 
ON medicalReport.id = outpatient.repID;

SELECT medicalReport.id as MedicalReportID, medicalReport.dateOfMaking as MedicalReport_DateOfMaking, 
inpatient.id as InpatientID, inpatient.daysOfStaying as InpatientDaysOfStaying
FROM medicalReport JOIN inpatient 
ON medicalReport.id = inpatient.repID;

SELECT  medicalReport.id as MedicalReportID, medicalReport.dateOfMaking as MedicalReport_DateOfMaking,
medicines.id as MedicinesID, medicines.name as NameOfMedicines, medicines.quantity as QuantityOfMedicines
FROM medicalReport JOIN medicines
ON medicalReport.id IN (SELECT repID
FROM rep_meds
WHERE medicines.id = rep_meds.medID);

SELECT patient.name as NameOfPatient, patient.egn as EgnOfPatient, patient.address as AddressOfPatient, 
patient.diagnosis as DiagnosisOfPatient, patient.gender as GenderOfPatient, patient.age as AgeOfPatient, 
bill.priceMeds, bill.priceRep, (SUM(priceMeds) + SUM(priceRep)) as GeneralPaymentAmount, bill.paid as PaidOrNot
FROM patient JOIN bill
ON patient.id = bill.patientID
GROUP BY bill.id;

SELECT room.id as RoomID, room.type as TypeOfRoom, room.status as StatusOfRoom, inpatient.daysOfStaying, 
patient.name as NameOfPatient, patient.diagnosis as DiagnosisOfPatient, patient.gender as GenderOfPatient
FROM inpatient JOIN patient
ON inpatient.repID IN (SELECT medicalReport.id
FROM medicalReport 
WHERE medicalReport.patientID = patient.id)
JOIN room 
ON room.id = inpatient.roomID;

SELECT outpatient.id as OutpatientID, outpatient.daysOfTreatment as OutpatientDaysOfTreatment,
patient.name as NameOfPatient, patient.diagnosis as DiagnosisOfPatient, patient.gender as GenderOfPatient, 
patient.age as AgeOfPatient, patient.egn as EgnOfPatient, patient.address as AddressOfPatient
FROM outpatient JOIN patient
ON outpatient.repID IN (SELECT medicalReport.id
FROM medicalReport 
WHERE medicalReport.patientID = patient.id);

/*OUTER JOIN*/
SELECT patient.name as NameOfPatient, patient.egn as EgnOfPatient, patient.diagnosis as DiagnosisOfPatient, 
patient.gender as GenderOfPatient, patient.age as AgeOfPatient, doctor.name as NameOfDoctor, doctor.room RoomOfDoctor, 
doctor.phone as PhoneOfDoctor, doctor.healthFund, doctor.specialization as SpecializationOfDoctor
FROM patient LEFT JOIN doctor 
ON patient.id IN(SELECT patientID
FROM patient_doctor
WHERE patient_doctor.doctorID = doctor.id);

SELECT patient.name as NameOfPatient, patient.egn as EgnOfPatient, patient.diagnosis as DiagnosisOfPatient, 
patient.gender as GenderOfPatient, patient.age as AgeOfPatient, doctor.name as NameOfDoctor, doctor.room RoomOfDoctor, 
doctor.phone as PhoneOfDoctor, doctor.healthFund, doctor.specialization as SpecializationOfDoctor
FROM patient RIGHT JOIN doctor 
ON patient.id IN(SELECT patientID
FROM patient_doctor
WHERE patient_doctor.doctorID = doctor.id);
 
(SELECT patient.name as NameOfPatient, patient.egn as EgnOfPatient, patient.diagnosis as DiagnosisOfPatient, 
patient.gender as GenderOfPatient, patient.age as AgeOfPatient, doctor.name as NameOfDoctor, doctor.room RoomOfDoctor, 
doctor.phone as PhoneOfDoctor, doctor.healthFund, doctor.specialization as SpecializationOfDoctor
FROM patient LEFT JOIN doctor 
ON patient.id IN(SELECT patientID
FROM patient_doctor
WHERE patient_doctor.doctorID = doctor.id))
UNION
(SELECT patient.name as NameOfPatient, patient.egn as EgnOfPatient, patient.diagnosis as DiagnosisOfPatient, 
patient.gender as GenderOfPatient, patient.age as AgeOfPatient, doctor.name as NameOfDoctor, doctor.room RoomOfDoctor, 
doctor.phone as PhoneOfDoctor, doctor.healthFund, doctor.specialization as SpecializationOfDoctor
FROM patient RIGHT JOIN doctor 
ON patient.id IN(SELECT patientID
FROM patient_doctor
WHERE patient_doctor.doctorID = doctor.id));

SELECT  medicalReport.id as MedicalReportID, medicalReport.dateOfMaking as MedicalReport_DateOfMaking,
medicines.id as MedicinesID, medicines.name as NameOfMedicines, medicines.quantity as QuantityOfMedicines
FROM medicalReport LEFT JOIN medicines
ON medicalReport.id IN (SELECT repID
FROM rep_meds
WHERE medicines.id = rep_meds.medID);

SELECT medicalReport.id as MedicalReportID, medicalReport.dateOfMaking as MedicalReport_DateOfMaking, 
inpatient.id as InpatientID, inpatient.daysOfStaying as InpatientDaysOfStaying
FROM medicalReport LEFT JOIN inpatient 
ON medicalReport.id = inpatient.repID;

SELECT medicalReport.id as MedicalReportID, medicalReport.dateOfMaking as MedicalReport_DateOfMaking, 
outpatient.id as OutpatientID, outpatient.daysOfTreatment as OutpatientDaysOfTreatment
FROM medicalReport LEFT JOIN outpatient 
ON medicalReport.id = outpatient.repID;

SELECT doctor.name as NameOfDoctor, doctor.specialization as SpecializationOfDoctor, 
patient.name as NameOfPatient, patient.diagnosis as DiagnosisOfPatient,
medicalReport.id as MedicalReportID, medicalReport.dateOfMaking
FROM patient LEFT JOIN doctor 
ON patient.id IN(SELECT patientID
FROM patient_doctor
WHERE patient_doctor.doctorID = doctor.id)
LEFT JOIN medicalReport
ON patient.id = patientID;

SELECT doctor.name as NameOfDoctor, doctor.specialization as SpecializationOfDoctor, 
patient.name as NameOfPatient, patient.diagnosis as DiagnosisOfPatient,
medicalReport.id as MedicalReportID, medicalReport.dateOfMaking
FROM patient RIGHT JOIN doctor 
ON patient.id IN(SELECT patientID
FROM patient_doctor
WHERE patient_doctor.doctorID = doctor.id)
LEFT JOIN medicalReport
ON patient.id = patientID;

(SELECT doctor.name as NameOfDoctor, doctor.specialization as SpecializationOfDoctor, 
patient.name as NameOfPatient, patient.diagnosis as DiagnosisOfPatient,
medicalReport.id as MedicalReportID, medicalReport.dateOfMaking
FROM patient LEFT JOIN doctor 
ON patient.id IN(SELECT patientID
FROM patient_doctor
WHERE patient_doctor.doctorID = doctor.id)
LEFT JOIN medicalReport
ON patient.id = patientID)
UNION 
(SELECT doctor.name as NameOfDoctor, doctor.specialization as SpecializationOfDoctor, 
patient.name as NameOfPatient, patient.diagnosis as DiagnosisOfPatient,
medicalReport.id as MedicalReportID, medicalReport.dateOfMaking
FROM patient RIGHT JOIN doctor 
ON patient.id IN(SELECT patientID
FROM patient_doctor
WHERE patient_doctor.doctorID = doctor.id)
LEFT JOIN medicalReport
ON patient.id = patientID);

/*Вложен SELECT*/
SELECT medicines.id as MedicinesID, medicines.name as NameOfMedicines, medicines.quantity as QuantityOfMedicines,
doctor.name as NameOfDoctor, doctor.specialization as SpecializationOfDoctor, 
doctor.phone as PhoneOfDoctor, doctor.healthFund
FROM medicalReport JOIN medicines
ON medicalReport.id IN (SELECT repID
FROM rep_meds
WHERE medicines.id = rep_meds.medID)
JOIN doctor 
ON doctor.id = medicalReport.doctorID;

SELECT medicines.id as MedicinesID, medicines.name as NameOfMedicines, medicines.quantity as QuantityOfMedicines,
patient.name as NameOfPatient, patient.diagnosis as DiagnosisOfPatient, patient.gender as GenderOfPatient, 
patient.age as AgeOfPatient
FROM medicalReport JOIN medicines
ON medicalReport.id IN (SELECT repID
FROM rep_meds
WHERE medicines.id = rep_meds.medID)
JOIN patient 
ON patient.id = medicalReport.patientID;

SELECT doctor.name as NameOfDoctor, doctor.specialization as SpecializationOfDoctor, doctor.phone as PhoneOfDoctor,
inpatient.id as InpatientID, inpatient.daysOfStaying as InpatientDaysOfStaying
FROM inpatient JOIN doctor
ON inpatient.repID IN (SELECT medicalReport.id 
FROM medicalReport 
WHERE doctor.id = medicalReport.doctorID);

/*1:1 RELATIONS MISTAKE CHANGE*/
ALTER TABLE medicalReport
ADD UNIQUE (patientID);

ALTER TABLE outpatient 
ADD UNIQUE (repID);

ALTER TABLE inpatient 
ADD UNIQUE (repID);

/*Tiggers*/ 
DROP TRIGGER IF EXISTS validatePatient;
DELIMITER $$
CREATE TRIGGER validatePatient
BEFORE INSERT ON patient
FOR EACH ROW
BEGIN

  DECLARE errorMsg VARCHAR(255);
  DECLARE month INT;
  DECLARE day INT;
  DECLARE checksum INT;
  
  SET month = CAST(SUBSTRING(NEW.egn, 3, 2) AS UNSIGNED);
  IF (month > 40) THEN
    SET month = month - 40;
    END IF;
  SET day = CAST(SUBSTRING(NEW.egn, 5, 2) AS UNSIGNED);
  SET checksum = ((SUBSTR(NEW.egn, 1, 1) * 2) + (SUBSTR(NEW.egn, 2, 1) * 4) +
    (SUBSTR(NEW.egn, 3, 1) * 8) + (SUBSTR(NEW.egn, 4, 1) * 5) +
    (SUBSTR(NEW.egn, 5, 1) * 10) + (SUBSTR(NEW.egn, 6, 1) * 9) +
    (SUBSTR(NEW.egn, 7, 1) * 7) + (SUBSTR(NEW.egn, 8, 1) * 3) +
    (SUBSTR(NEW.egn, 9, 1) * 6))% 11;
  IF checksum = 10 THEN
	SET checksum = 0;
  END IF;

  IF LENGTH(NEW.egn) <> 10 THEN
    SET errorMsg = 'Invalid EGN length';
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errorMsg;
  END IF;
  IF month > 12 THEN
    SET errorMsg = 'Invalid EGN month';
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errorMsg;
  END IF;
  IF day > 31 THEN
    SET errorMsg = 'Invalid EGN day';
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errorMsg;
  END IF;
  IF checksum <> CAST(SUBSTRING(NEW.egn, 10, 1) AS UNSIGNED) THEN
	SET errorMsg = 'Invalid EGN';
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errorMsg;
  END IF;
  
  IF LENGTH(NEW.name) - LENGTH(REPLACE(NEW.name, ' ', '')) < 2 THEN
    SET errorMsg = 'Invalid name, write 3 names or more';
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errorMsg;
  END IF;
    
END $$
DELIMITER ;

DESCRIBE patient;
INSERT INTO patient (name, egn, address, diagnosis, gender, age) 
VALUES ('John Marsell Marshall', '024822673', 'Sofia, zh.Lulin 8', 'Acne', 'Female', '62');

/*Procedure and Cursor*/
DROP PROCEDURE IF EXISTS monthlyPatientsReports;
DELIMITER $$
CREATE PROCEDURE monthlyPatientsReports()
BEGIN
    DECLARE done INT;
    DECLARE cur_month VARCHAR(255);
    DECLARE cur_id INT;
    DECLARE monthlyCursor CURSOR FOR SELECT DATE_FORMAT(dateOfMaking, '%M') as month, 
    COUNT(id) as totalReports
        FROM medicalReport
        WHERE dateOfMaking IS NOT NULL
        GROUP BY month
        ORDER BY month;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    SET done = 0;
    CREATE TEMPORARY TABLE monthlyReports(
    tempTableMonth VARCHAR(255) NULL,
    tempTableId INT NULL,
    UNIQUE(tempTableMonth, tempTableId)
    ) ENGINE = Memory;

    OPEN monthlyCursor;
    SET cur_month = 0;
    SET cur_id = 0;
    read_loop: LOOP
        FETCH  monthlyCursor INTO cur_month, cur_id;
        INSERT INTO monthlyReports (tempTableMonth, tempTableId) 
        VALUES (cur_month, cur_id)
        ON DUPLICATE KEY UPDATE tempTableId = cur_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
	/*SELECT CONCAT('Total medical reports for month ', cur_month, 'are ', cur_id) as Result;*/

    END LOOP;
    
    SELECT tempTableMonth as Month, tempTableId as numberOfMedReport 
    FROM monthlyReports;
    DROP TABLE monthlyReports;
    
    CLOSE monthlyCursor;
    
END $$
DELIMITER ;

CALL monthlyPatientsReports();

DROP PROCEDURE IF EXISTS createBirthDate;
DELIMITER $$
CREATE PROCEDURE createBirthDate()
BEGIN
    DECLARE done INT;
    DECLARE cur_egn VARCHAR(10);
    DECLARE cur_name VARCHAR(255);
    DECLARE month INT;
    DECLARE day INT;
    DECLARE year INT;
    DECLARE birth_date DATE;
    DECLARE dateCursor CURSOR FOR SELECT name as nameOfPatient, egn
        FROM patient
        WHERE egn IS NOT NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    SET done = 0;
    CREATE TEMPORARY TABLE BirthDates(
    tempName VARCHAR(255) NULL UNIQUE,
    tempEgn VARCHAR(10) NULL UNIQUE,
    tempBirth_date DATE UNIQUE
    ) ENGINE = Memory;

    OPEN dateCursor;
    SET cur_name = 0;
    SET cur_egn = 0;
    read_loop: LOOP
        FETCH dateCursor INTO cur_name, cur_egn;
        SET year = CAST(CONCAT('19', SUBSTRING(cur_egn, 1, 2)) AS UNSIGNED);
		IF (CAST(SUBSTRING(cur_egn, 3, 2) AS UNSIGNED) > 40) THEN
			SET year = CAST(CONCAT('20', SUBSTRING(cur_egn, 1, 2)) AS UNSIGNED);
		END IF;
        SET month = CAST(SUBSTRING(cur_egn, 3, 2) AS UNSIGNED);
        IF (month > 40) THEN
			SET month = month - 40;
		END IF;
        SET day = CAST(SUBSTRING(cur_egn, 5, 2) AS UNSIGNED);
        SET birth_date = STR_TO_DATE(CONCAT(year, '-', month, '-', day), '%Y-%m-%d');
        INSERT INTO BirthDates (tempName, tempEgn, tempBirth_date) 
        VALUES (cur_name, cur_egn, birth_date)
        ON DUPLICATE KEY UPDATE tempEgn = cur_egn;
        IF done THEN
            LEAVE read_loop;
        END IF;
    END LOOP;
    
    SELECT tempName as nameOfPatient, tempEgn as EGN, tempBirth_date as birthDate
    FROM BirthDates;
    DROP TABLE BirthDates;
    
    CLOSE dateCursor;
    
END $$
DELIMITER ;

CALL createBirthDate();

