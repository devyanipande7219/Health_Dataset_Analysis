create database healthdb;
use healthdb;

select *from patients;
select*from appointments;
select*from billing;
select*from doctors;
select*from prescriptions;

-- get all appointments for a specific patient
select*from appointments
where patient_id = 1;

-- retrieve all prescriptions for a specific appointment
select *from Prescriptions
where appointment_id = 1;

-- get billing information for a specific appointment
select *from billing
where appointment_id = 2;

-- list all appointments with billing status
select a.appointment_id,p.first_name as patient_first_name,p.last_name as patient_last_name,
d.first_name as doctor_first_name,d.last_name as doctor_last_name,
b.amount,b.payment_date,b.status
from appointments a
join patients p on a.patient_id = p.patient_id
join doctors d on a.doctor_id = d.doctor_id
join billing b on a.appointment_id = b.appointment_id;

-- find all paid billing
select*from billing
where status = 'paid';

-- calculate total amount billed and total paid amount
select
(select sum(amount) from billing) as total_billed,
(select sum(amount) from billing where status = 'paid') as total_paid;

-- get the number of appointments by specialty
select d.specialty,count(a.appointment_id) as number_of_appointments
from appointments a
join doctors d on a.doctor_id = d.doctor_id
group by d.specialty;

-- find the most common reason for appointments
select reason,
count(*) as count
from appointments
group by reason
order by count desc;

-- list patients with their lastest appointments date
select p.patient_id,p.first_name,p.last_name,max(a.appointment_date) as lastest_appointments
from patients p
join appointments a on p.patient_id = a.patient_id
group by p.patient_id,p.first_name,p.last_name;

-- list all doctors and the number of appointments the had
select d.doctor_id,d.first_name ,d.last_name,count(a.appointment_id) as number_of_appointments
from doctors d
left join appointments a on d.doctor_id = a.doctor_id
group by d.doctor_id,d.first_name,d.last_name;

-- retrive patients who had appointments in the last 90 days
select distinct p.*
from patients p
join appointments a on p.patient_id = a.patient_id
where str_to_date(a.appointment_date,'%d-%m-%Y') >= curdate() - interval 300 day;

-- find prescriptions associated with appointments that are pending payment
select pr.prescription_id,pr.medication,pr.dosage,pr.instructions
from prescriptions pr
join appointments a on pr.appointment_id = a.appointment_id
join billing b on a.appointment_id = b.appointment_id
where b.status = 'pending';

-- analyse patient demographics
select gender,count(*) as count
from patients
group by gender;

-- identify the most frequently prescribed medications and their total dosage
select medication ,count(*) as frequency ,sum(cast(substring_index(dosage,'',1) as unsigned )) as total_dosage
from prescriptions
group by medication
order by frequency desc;

-- average billing amount by number of appointments
select p.patient_id,count(a.appointment_id) as appointment_count,
avg(b.amount) as avg_billing_amount
from patients p
left join appointments a on p.patient_id = a.patient_id
left join billing b on a.appointment_id = b.appointment_id
group by p.patient_id;

-- day wise appointment counts
select appointment_date ,count(*) as appointment_count
from appointments
group by appointment_date;

-- find patients with missing appointement
select p.patient_id,p.first_name,p.last_name
from patients p
left join appointments a on p.patient_id = a.patient_id
where a.appointment_id is null;





