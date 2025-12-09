create database Home_Automation;
Use Home_Automation;
-- 1) Show all data
select * from smart_home_automation;
-- insights is check all data 
-- 2) find total records 
select count(*) from smart_home_automation;
-- 18,763 events logged
-- 3) how many unique homes 
select count(distinct home_id) as total_home 
from smart_home_automation;
-- 99 Smart Homes monitored
-- 4) total energy consumpation
select count(energy_consumption_kWh) from smart_home_automation;
-- 18763 kWh
-- 5) Average energy consumption per event
select avg(energy_consumption_kWh) as total_engy 
from smart_home_automation;
-- average ogf energy is 2.5638
-- 6) Min–Max temperature setting
select max(temperature_setting_C) as max_tem,min(temperature_setting_C) as min_tem from smart_home_automation;
-- Heater + AC usage patterns
-- 7) list all appainces 
select distinct appliance from smart_home_automation;
-- Appliance diversity → analysis direction set
-- 8) count holidays 
select count(holiday) as holiday_count from smart_home_automation where holiday = 1;
-- 1804 is total holiday Holiday usage vs normal usage comparison
-- 9) Maximum usage duration
select max(usage_duration_minutes) as max_uses from smart_home_automation;
-- 119 minute is max uses duration Longest-running devices identify.
-- 10 ) count recored per season 
select season, count(*) as count_season  from smart_home_automation group by season;
-- grouping recored per season,Season = key factor for energy variation.
-- 11) Total energy consumption per home
select home_id, sum(energy_consumption_kWh) as total_ene_home from smart_home_automation 
group by home_id 
order by total_ene_home desc;
-- home_id 90 uses maximum energy 
-- 12) Average usage duration per appliance
select appliance, avg(usage_duration_minutes) as appliance_minute from smart_home_automation
group by appliance 
order by appliance_minute desc;
-- washing machine is most useble appliance 
-- 13) Season-wise total energy consumption
select season, sum(energy_consumption_kWh) from smart_home_automation
group by season;
-- in string season energy consumption is high because of heater energy_consumption_kWh
-- 14) Day_of_week wise average temperature
select day_of_week, avg(temperature_setting_C) as week_tem from smart_home_automation 
group by day_of_week
order by week_tem desc;
-- Weekend temperature slightly higher. friday, saturday,sunday peak day of tenperature setting 
-- 15) Weekend vs Weekday energy
select 
case 
when day_of_week in ("Saturday","Sunday") then "Weekend"
else "Weekday"
end as day_type,
sum(energy_consumption_kWh)
from smart_home_automation
group by day_type;
-- 16) Holiday vs Non-holiday usage 
select holiday, sum(energy_consumption_kWh) as holiday_energy
from smart_home_automation 
group by holiday;
-- energy uses increaded on holidays,Relaxation day → energy spike.
-- 17)when Occupancy ON find avg energy
select occupancy_status, avg(energy_consumption_kWh) 
from smart_home_automation
group by occupancy_status;
--
-- 18) hour wise energy trend 
select Hour, sum(energy_consumption_kWh) as energy_hour
from smart_home_automation
group by hour 
order by energy_hour desc;
-- 4 am and 6 pm is peak time 4 am is  wake up time and 6 pm job drop time 
-- 19) Month-wise trend
select month,sum(energy_consumption_kWh) as month_energy
from smart_home_automation
group by month 
order by month_energy desc;
-- 1,2,12  month high uese beacuse og heater 
-- 20) top 5 high energy consumed appliance 
select appliance, sum(energy_consumption_kWh)as appliance_ene
from smart_home_automation
group by appliance
order by appliance_ene desc
limit 5;
-- lighting, refrigerator and washing machine is on top
-- 21) appliance per home
select home_id, count(distinct appliance) 
from smart_home_automation
group by home_id;
-- Automation complexity per home. 
-- 22) home wise total duration 
select home_id, sum(usage_duration_minutes) as totalMinute_home
from smart_home_automation
group by home_id;
 -- home no 44 is longest uses of appilance 
 -- 23) Day_of_week highest usage
 select day_of_week, sum(energy_consumption_kWh) as uses_day
 from smart_home_automation
 group by day_of_week
 order by uses_day desc;
-- sunday is high usage day
-- 24) Season-wise top appliance
select appliance, season, sum(usage_duration_minutes)  as minute_Dur
from smart_home_automation
group by appliance, season
order by minute_Dur desc;
-- Seasonal patterns directly visible.
-- 25) Month 12 peak hour
select Hour, sum(energy_consumption_kWh) as energy
from smart_home_automation
where Month = 12 
group by Hour
order by energy desc;
-- December night = highest load.
-- 26) occpacy = 1 hight energy hour
select Hour,sum( energy_consumption_kWh) as high_energy
from smart_home_automation
where Occpancy_status = 1
group by hour 
order by high_energy desc;
-- 7 AM and 8PM peak when home is occupied.real life behavioral pattern 
-- 27) Abnormal high usage
select * from smart_home_automation
where energy_consumption_kWh >
(select avg( energy_consumption_kWh)*1.5 from smart_home_automation);
-- About 2–5% events are abnormal spikes.
-- 28) Home efficiency score 
select home_id, (sum(usage_duration_minutes)/ sum(energy_consumption_kWh)) as efficiency
from  smart_home_automation
group by home_id
order by efficiency desc;
-- home id 88 = high efficiency, Savings potential highest.
-- 29) Appliance efficiency score 
select appliance, 
(sum(usage_duration_minutes)/sum(energy_consumption_kWh)) as appliance_effi
from smart_home_automation
group by  appliance
order by appliance_effi desc;
-- dishwasher have best efficiency
-- 30) Peak month
select Month, sum(energy_consumption_kWh) as peak_energy
from smart_home_automation
group by Month
order by peak_energy desc;
-- 1, 2 and 12 month is peak for energy beacouse og cold season
-- 31) High temp setting impact
select 
case when temperature_setting_C >= 28 then "High"
else "Normal"
end as temp_range, 
 avg(energy_consumption_kWh) 
 from smart_home_automation
 group by temp_range;
 -- no ac requried 
 -- 32) Month–Hour combined peak
 select Month,Hour ,
 sum(energy_consumption_kWh) as combined_peak
 from smart_home_automation
 group by Month,Hour
 order by combined_peak desc;
-- 1st month at 9AM and 1st Month 5AM peak energy 
-- 33) Season-wise appliance variation
select appliance, season,
count(*)as variation from smart_home_automation
group by appliance,season; 
-- Weather-sensitive appliances follow predictable patterns.
-- 34) Total electricity bill per home [8rs per kWh]
select home_id, sum(energy_consumption_kWh)*8  as electricity_bill
from smart_home_automation
group by home_id
order by electricity_bill;
-- home_id 83 = high electricity bill 
-- 35) Peak-hour penalty cost (20% extra)
select sum(energy_consumption_kWh*0.2*8) as penalty_cost
from smart_home_automation
where hour between 19 and 22;
-- Peak-hour avoidance → savings.
-- 36) Wastage check: occupancy=0 but appliance on
select * from smart_home_automation
where Occpancy_status= 0 
and usage_duration_minutes > 0;
-- 7–10% events = wastage.
-- 37)Smart scheduling target appliances
select appliance,sum(energy_consumption_kWh) as total_energy 
from smart_home_automation
group by appliance 
order by total_energy desc;
-- lighting, refrigerator and washing machine biggest targets
-- This project looked at energy use and appliance patterns in 99 smart homes, covering 18,763 events. On average, each event used about 2.56 kWh. Energy use was highest in winter, during mornings and evenings, and on holidays. Lighting, refrigerators, and washing machines used the most energy, while the dishwasher was the most efficient. Studying occupancy, seasons, and unusual spikes helped find ways to save energy and plan appliance use better.