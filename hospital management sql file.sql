create database hospital_data;
use hospital_data;
select * from admissions;
select * from doctors;
select * from patients;
select * from province_names;
-- Show first name,last name and gender of patients whose gender is "M"

select first_name, last_name, gender 
from patients
where gender = "M";

-- show first name and last name of patients that weight within the range of 100 to 120

select first_name, last_name, weight 
from patients
where weight between 100 and 120;

-- show first name of patients that start with the letter "c"

select first_name from patients
where first_name like "c%";

-- show first name and last name concatinated into one column to show their full name

select concat(first_name," ", last_name)
from patients;

-- show first name, last name, and the full province name of ecah patients

select first_name , last_name, province_name
from patients
inner join
province_names on patients. province_id = province_names.province_id;

-- show how many patients have a birthdate with 2010 as the birth year

select
count(*) as total_patients
from patients
where year(birth_date) = 2010;

-- show the fist name, last name , and height of the patient with the greatest height

select first_name, last_name, height
from patients
order by height desc
limit 1;

-- show all columns for patients who have one of the following patient_ids:1,45,534,879,1000.

select * from patients
where patient_id in (1, 45, 534,879,1000);

-- show number of admission

select
count(*) as total_admission
from admissions;

-- show all the columns from admissions where the patient was admitted and discharged on the same day

select * from admissions
where admission_date like discharge_date;

-- show the patient id and the total number of admission for patient_id 579
select patient_id, count(*) as total_admissions 
from admissions
where patient_id = 579;

-- based on the cities that our patients live in, show unique cities that are in province_id "NS"

select distinct(city) as unique_city
from patients
where province_id = "NS";

-- write a query to find the first name, last name and birth date of patients who has height greater than 160 and weight greater than 70

select first_name, last_name,birth_date
from patients
where height > 160 and weight > 70;

-- write a query to find list of patientsfirst name, last name, and allergies where allergies are not null and are from the city of "hamilton"

select first_name, last_name, allergies
from patients
where allergies is not null
and city = "Hamilton";

-- medium level queries

-- show unique birth years from patients and order tham by ascending

select distinct (year(birth_date)) as unique_birth_years 
from patients
order by year(birth_date);

-- show unique first names from the patients table which only occurs once in the list.
-- for example, if two or more people are named "john" in the first name column than don't include their 
-- name in the output list. if only 1 person is names "lee" then include them in the output.
select first_name
from patients
group by first_name
having count(first_name) = 1;

-- show patient_id and first_name from patients where their first_name start and ends with "s" and is at least 6 characters long
select patient_id, first_name
from patients
where first_name like "s____%s";

-- show the total amount of male patients and the total amount of female patients table. display the two results in the same row.

select
(select count(*) from patients where gender = "m") as male_count,
(select count(*) from patients where gender = "F") as female_count;

-- show patient_id, first_name, last_name from patients whos diagnosis is ' dementia'
select patients.patient_id, first_name, last_name
from patients
join
admissions on patients.patient_id = admissions.patient_id
where diagnosis = "Dementia";

-- show first and last name, allergies from patients which have allergies to either 'penicillion' or 'morphine'
-- show results ordered ascending by alleries then by first_name then by last_name
select first_name, last_name, allergies
from patients
where allergies in ("penicillion" , "morphine")
order by allergies, first_name, last_name;

-- show patient_id, diagnosis from admissions. find patients admitted multiple times for the same diagnosis

select patient_id,diagnosis
from admissions
group by patient_id, diagnosis
having count(*) > 1;
-- show the city and the total number of patients in the city . order from most to least patients and then by city name ascending
select city, count(*) as num_patients
from patients
group by city
order by num_patients desc, city asc;

-- show first name, last name and role of every person that is either patient or doctor. the roles are either " potient", "doctor"

select first_name, last_name, "patient" as role 
from patients
union all
select first_name, last_name, "Doctor"
from Doctors;

-- show all allergies ordered by popularity. remove null values from query

select allergies, count(*) as total_dignosis
from patients
where allergies is not null
group by allergies
order by total_dignosis desc;

-- we want to display each patients full name in a single column. their last name in all upper letters
-- must appear first name in all lower case letters. separate the last name and first name with a comma. order the 
-- list by the first name in decending order.
select
concat(upper(last_name)," , ", lower(first_name)) as full_name
from patients
order by first_name desc;

-- show the province_id, sum of height , where the total su of its patients height is greater than or eqal to 7000
select province_id, sum(height) as sum_height
from patients
group by province_id
having sum_height >= 7000;

-- show the differnece between the largest weight and smallest weight for patients with the last name ' marani'
select
(max(weight) - min(weight)) as weight_diff
from patients
where last_name = 'maroni';

-- show all of the days of the month and how many admission_dates accured on that day. sort by the day with most admissions to least admissions
select
day(admission_date) as day_number,
count(*) as number_of_admissions
from
admissions
group by day_number
order by number_of_admissions desc;

-- show first name, last name and the total number of admissions attended for each doctor.
-- every admission has been attended by a doctor.
select first_name,last_name,
count(*) as admissions_total
from
admissions a
join
doctors d on d.doctor_id= a.attending_doctor_id
group by attending_doctor_id;

-- for each doctor, display their id, full name, and the first and last admissions date they attened
select
doctor_id, first_name," ", last_name as full_name,
min(admission_date) as first_admission_date,
max(admission_date) as last_admission_date
from
admissions a
 join
doctors ph on a.attending_doctor_id = ph.doctor_id
group by doctor_id;

-- display the total amount of patients for each province. order by descending.
select
province_name, count(*) as patient_count
from
patients  pa
join
province_names pr on pr.province_id = pa.province_id
group by pr.province_id
order by patient_count desc;

-- foe every admission,display the patients full name, their admission diagnosis, and their doctors full name
-- who diagnosed their problem.
select
    concat(patients.first_name," ",
    patients.last_name) as patient_name,
    diagnosis,
    concat(doctors.first_name," ",
    doctors.last_name) as doctor_name
from
  patients
    join
    admissions on admissions.patient_id = patients.patient_id
    join
    doctors on doctors.doctor_id = admissions.attending_doctor_id;

-- display the first name, last name and number of duplicate patients based on their first name and lat name
select
first_name, last_name, count(*) as num_of_duplicates
from
patients
group by first_name, last_name
having count(*) > 1;

    
