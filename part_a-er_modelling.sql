--
-- @StudentID: *****
--
--
-- Designed for PostgreSQL with PostGIS

-- ----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS clinics;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS diseases;
DROP TABLE IF EXISTS doctor_work_clinic;
DROP TABLE IF EXISTS diseases_occurence;
DROP TABLE IF EXISTS clinic_treat_patient;

-----------------------------------------------------------------------------------------
-- Define tables
-----------------------------------------------------------------------------------------


CREATE TABLE doctors (
    doctor_id		integer		PRIMARY KEY,
    doctor_name		text		NOT NULL,
    doctor_date_of_birth	date		NOT NULL,
    speciality		text		UNIQUE  -- (related to disease treatment)
);

CREATE TABLE clinics (
    clinic_id		integer		PRIMARY KEY,
    clinic_name		text		NOT NULL,
    clinic_address		text		NOT NULL
    --catchment_area	geometry(polygon)	NOT NULL -- to be added later
);


CREATE TABLE patients (
    patient_id		integer		PRIMARY KEY,
    patient_name	text		NOT NULL,
    patient_date_of_birth	date		NOT NULL,
    patient_date_of_death	integer,	
    patient_gender		varchar(1), -- e.g. F or M (or 0 for other)
    patient_address		text		NOT NULL
    -- patient_location		geography(point)	NOT NULL -- to be added later	
);
 

CREATE TABLE diseases ( 
    disease_id		integer		PRIMARY KEY,
    disease_name	text		NOT NULL,
    disease_speciality	text		NOT NULL		REFERENCES doctors(speciality)
    
);

-- Doctors who work in various clinics, one doctor can work at many clinics
 
CREATE TABLE doctor_work_clinic (
    clinic_workplace		integer		NOT NULL	REFERENCES clinics(clinic_id), -- specific clinic 
    clinic_doctor		integer		NOT NULL	REFERENCES doctors(doctor_id) -- doctor who works at this clinic
    --PRIMARY KEY (clinic_id, doctor_id) -- multiple primary key
);

-- Diseases affect multiple patients, and one patient can have several diseases.
-- Next table shows a single disease occurance
 
CREATE TABLE disease_occurence (
    disease_occurence_id	integer		PRIMARY KEY,
    patient_w_disease		integer		NOT NULL	REFERENCES patients(patient_id), -- patient affected by specific disease
    disease_occured		integer		NOT NULL	REFERENCES diseases(disease_id), -- disease
    severity_level	varchar(1)	NOT NULL, -- e.g. L (low), M (medium), H (high) 
    disease_start_date		integer,		 -- when occured
    disease_end_date		integer,
    patient_recovered		varchar(1)	NOT NULL -- e.g. Y (yes) or N (died)

    --PRIMARY KEY (patient_id, disease_id) -- multiple primary key
);


-- Clinics treat multiple patients, one patient belongs to one clinic.
-- Table shows treatments of one disease in one patient, with doctor assigned
 
CREATE TABLE clinic_treat_patient (
    disease_treat	integer		NOT NULL	REFERENCES	disease_occurence(disease_occurence_id), -- disease that's being treated
    clinic_treat		integer		NOT NULL	REFERENCES clinics(clinic_id), -- specific clinic
    doctor_treat		integer		NOT NULL	REFERENCES doctors(doctor_id), -- doctor assigned to this patient
    PRIMARY KEY (disease_treat, doctor_treat, clinic_treat) -- multiple primary key
);


-- ---------------------------------------------------------------------------------------
-- Populate tables
-- ---------------------------------------------------------------------------------------

INSERT INTO doctors (doctor_id, doctor_name, doctor_date_of_birth, speciality) VALUES 
(1,'Charles Hodgson','1966-04-28', 'Cardiology'),
(2,'Eva Warner', '1959-05-04', 'Infectious disease'),
(3,'Marcel Kalb', '1976-01-03', 'Neurosurgery'),
(4,'Eva Warner', '1990-03-02', 'Pathology'),
(5, 'Bent I. Henriksen', '1967-04-05', 'Toxicology'),
(6, 'Yi Wan', '1984-12-12', 'Urology'),
(7, 'Ilve Olvera Porras', '1979-05-30', 'Rheumatology'),
(8, 'Venko Kacil', '1977-04-06', 'Intensive care medicine'),
(9, 'Orazio Trevisani', '1971-03-03', 'Hematology'),
(10, 'Larisa Yermolayeva', '1984-01-12', 'Obstetrics and gynecology');


INSERT INTO clinics (clinic_id, clinic_name, clinic_address) VALUES 
(1, 'Clinic 1', '67 Landsdowne Road Bournemouth Dorset BH1 1RW'),
(2, 'Clinic 2', 'Shenfield Road Brentwood Essex CM15 8EH'),
(3, 'Clinic 3', 'Warren Road Woodingdean Brighton BN2 6DX'),
(4, 'Clinic 4', '3 Clifton Hill Clifton Bristol Avon BS8 1BN'),
(5, 'Clinic 5', 'Hatherley Lane Cheltenham Gloucestershire GL51 6SY'),
(6, 'Clinic 6', '78 Broyle Road Chichester PO19 6WB'),
(7, 'Clinic 7', 'Rykneld Road Littleover Derby Derbyshire DE23 4SN'),
(8, 'Clinic 8', 'Stirling Road Guildford Surrey GU2 7RF'),
(9, 'Clinic 9', 'Burrell Road Haywards Heath RH16 1UD'),
(10, 'Clinic 10','Derriford Road Plymouth Devon PL6 8BG');

INSERT INTO patients (patient_id, patient_name, patient_date_of_birth, patient_date_of_death, patient_gender, patient_address) VALUES 
(1, 'Arkadiusz Kalinowski', '1953-01-20', NULL, NULL, '12 Balsham Road HARTLEPOOL TS24 1XP' ),
(2,'Manchu Tsai', '1961-08-21', NULL, NULL, '6 Roman Rd LEDBURY HR8 5AL' ),
(3,'Lavinia Ferreira Gomes', '1985-06-20', 2019, 'F', '46 Clasper Way HERTFORD SG13 7ZW' ),
(4,'Joe Hargreaves', '1921-01-03', 2005, 'M', '50 Shannon Way CHISLEHURST CAVES BR7 3ZX' ),
(5, 'Amelia Doherty', '1985-03-06', NULL, 'F', '61 Canterbury Road VIGO WS9 7QG' ),
(6, 'Mahmud Haytham Tuma', '1984-09-28', NULL, 'M', '71 Old Chapel Road GEDNEY PE12 8JA' ),
(7, 'Oda Isaksen', '1940-03-28', 2009, 'F', '71 Newport Road CARLTON DN14 7LB' ),
(8, 'Felicita Rizzo', '1990-05-13', NULL, 'F', '65 Neville Street ILSTON SA2 9QH'),
(9, 'Joe McIntyre', '2000-07-19', 2020, 'M', '78 Tadcaster Rd PIERCEBRIDGE DL2 6BD' ),
(10, 'Nate Shearston', '1955-01-26', 1999, 'M', '11 Fordham Rd HALLS GREEN SG4 4GJ' );

INSERT INTO diseases (disease_id, disease_name, disease_speciality) VALUES 
(1,'Arrhythmia', 'Cardiology'),
(2,'Tuberculosis', 'Infectious disease'),
(3,'Brain tumor', 'Neurosurgery'),
(4,'Asthenia', 'Pathology'),
(5,'Chemical poisoning', 'Toxicology'),
(6,'Kidney stones', 'Urology'),
(7,'Rheumatoid arthritis', 'Rheumatology'),
(8,'Drug overdose', 'Intensive care medicine'),
(9,'Anemia', 'Hematology'),
(10,'Endometriosis', 'Obstetrics and gynecology');


INSERT INTO doctor_work_clinic (clinic_workplace, clinic_doctor) VALUES
(1,8),
(1,4),
(2,3),
(2,2),
(3,4),
(4,10),
(4,1),
(4,2),
(5,1),
(5,7),
(6,3),
(7,6),
(7,5),
(8,9),
(9,7),
(10,1),
(10,8),
(10,5),
(10,3),
(10,4);


INSERT INTO disease_occurence (disease_occurence_id, patient_w_disease, disease_occured, severity_level, disease_start_date, disease_end_date, patient_recovered) VALUES 
(1, 10, 6, 'H', 1995, 1999, 'N'),
(2, 1, 2, 'L', 2010, 2011, 'Y'),
(3, 9, 2, 'M', 2019, 2020, 'N'),
(4, 2, 3, 'H', 2018, 2019, 'Y'),
(5, 3, 9, 'M', 2019, 2019, 'N'),
(6, 8, 5, 'H', 2020, 2020, 'Y'),
(7, 4, 8, 'H', 2005, 2005, 'N'),
(8, 5, 10, 'L', 2019, 2019, 'Y'),
(9, 7, 8, 'H', 2009, 2009, 'N'),
(10, 6, 7, 'M', 2012, 2013, 'Y');


INSERT INTO clinic_treat_patient (disease_treat, clinic_treat, doctor_treat) VALUES
(1, 7, 6),
(2, 2, 2),
(3, 4, 2),
(4, 2, 3),
(5, 8, 9),
(6, 7, 5),
(7, 10, 8),
(8, 4, 10),
(9, 10, 8),
(10, 5, 7);


-----------------------------------------------------------------------------------------
-- End of DB -- queries next 
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- All patients that died
-----------------------------------------------------------------------------------------

SELECT disease_occurence_id, patient_w_disease, disease_occured, severity_level, disease_start_date, disease_end_date, patient_recovered FROM disease_occurence WHERE patient_recovered = 'N';

-----------------------------------------------------------------------------------------
-- All patients that died at specific clinics from disease
-----------------------------------------------------------------------------------------

SELECT * FROM clinic_treat_patient WHERE disease_treat IN
(SELECT disease_occurence_id FROM disease_occurence WHERE patient_recovered = 'N');

-----------------------------------------------------------------------------------------
-- Number of diseases (patients) treated by each doctor
-----------------------------------------------------------------------------------------

SELECT COUNT(disease_treat) as disease, doctor_treat
FROM clinic_treat_patient
GROUP BY doctor_treat;

-----------------------------------------------------------------------------------------
-- Disease that occurs most often
-----------------------------------------------------------------------------------------

SELECT COUNT(disease_occurence_id) as frequency, disease_occured
FROM disease_occurence
GROUP BY disease_occured
ORDER BY COUNT(disease_occurence_id) DESC;

-----------------------------------------------------------------------------------------
-- Number of patients died in a given clinic & while treated by doctor in a year and mortality
-----------------------------------------------------------------------------------------

select d.disease_occurence_id as disease, d.patient_w_disease as patient, d.patient_recovered,
d.disease_end_date as year_of_death, count(d.disease_end_date) as died_this_year,
count(d.disease_occurence_id) / count(d.disease_end_date) as mortality_rate,
c.doctor_treat as doctor, c.clinic_treat as clinic,
count(d.disease_end_date) * count(c.clinic_treat) as died_at_this_clinic,
count(d.disease_end_date) * count(c.doctor_treat) as died_at_this_doctor
from disease_occurence as d
join clinic_treat_patient as c
on d.disease_occurence_id = disease_treat
where d.patient_recovered = 'N'
group by d.disease_occurence_id ,c.clinic_treat,c.doctor_treat,c.disease_treat;


-- End of File --