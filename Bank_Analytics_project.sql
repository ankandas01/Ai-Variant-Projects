#--------------------------------------------------------BANK LOAN ANALYTICS--------------------------------------------------------------#



# some necessities before begining with the KPI's

create database bank_analytics;                                  #setting the schema name as the project name
use bank_analytics;
show tables;
rename table finance_1 to finance1;
rename table finance_2 to finance2;
desc finance1;
desc finance2;
alter table finance2 modify column earliest_cr_line date;
alter table finance1 modify column issue_d date;                  #changed the column datatype from text to date format yyyy-mm-dd
#------------------------------------------------------------------------------------------------------------------------------------#




# KPI 1 : YEAR WISE LOAN AMOUNT STATS
select * from finance1;
select * from finance2;

SELECT 
    YEAR(issue_d) as Year,
    concat("$", " ",format(SUM(loan_amnt)/1000000,2)," ", "M") as `Loan Amount`
FROM
    finance1
GROUP BY 1
ORDER BY 1;
#-----------------------------------------  KPI 1 INSIGHTS ------------------------------------------------------------------------#
# There's a clear upward trend in loan amounts over the years, with each year showing a substantial increase from the previous one.
# The most dramatic increase occurred between 2010 and 2011, with the loan amount more than doubling from 122.05M to 260.51M.
#----------------------------------------------------------------------------------------------------------------------------------#

# KPI 2 : Grade and sub grade wise revol_bal
select * from finance1;
select * from finance2;

select grade as Grade, 
sub_grade as `Sub-Grade`, 
concat("$"," ",format(sum(revol_bal)/1000000, 2)," ", "M")as `Revolving Balance`
from finance1 
join finance2 
on finance1.id = finance2.ï»¿id
group by 1,2
order by 1,2 desc;
#-----------------------------------------  KPI 2 INSIGHTS--------------------------------- -------------------------------------------#
# Grade and sub-grade wise revolving are shown in descending order.
# Grades (A and B) tend to have higher balances overall.
#--------------------------------------------------------------------------------------------------------------------------------------#

# KPI 3 : Verified Payment vs Non-verified payment status
SELECT *FROM finance1;
SELECT *FROM finance2;

SELECT 
    verification_status AS `Verification Status`,
    concat("$"," ",FORMAT(SUM(total_pymnt) / 1000000,2)," ","M") 
    AS `Total Payment Amount`
FROM finance1
JOIN
finance2 ON finance1.id = finance2.ï»¿id
WHERE
verification_status IN ("Verified" , "Not Verified")
GROUP BY verification_status;
#-----------------------------------------  KPI 3 INSIGHTS  ------------------------------------------------------------------------#
#Verified payments are significantly higher than Non-verified payments which is a good indication for healthy banking practice
#Verified payments are about 43% higher than Non-verified payments
#------------------------------------------------------------------------------------------------------------------------------------#

# KPI 4 : State wise and month wise loan status
select * from finance1; 
select * from finance2;

select addr_state as `State`,
 monthname(issue_d)as `Month`,
 loan_status as `Loan Status`, 
 count(id)as `Count of status`

from finance1
group by 1,2,3
order by 4 desc;
#-----------------------------------------  KPI 4 INSIGHTS -------------------------------------------------------------------------#
# Overall California tops the "fully paid" loan status by a big margin followed by New York and Texas
# "fully paid" loan status holds more weightage across the states which signifies a credit worthiness of the customers
#-----------------------------------------------------------------------------------------------------------------------------------#

# KPI 5 : Home Ownership by Last_payment_date_stats
SELECT * FROM FINANCE1;
SELECT * FROM FINANCE2;
SELECT 
    home_ownership as `Home Ownership`,
    (format(COUNT(last_pymnt_d), 0)) AS `Last Payment Date Stats`
FROM
    finance1
        JOIN
    finance2 ON finance1.id = finance2.ï»¿id
GROUP BY home_ownership;
#-----------------------------------------  KPI 5 INSIGHTS -------------------------------------------------------------------------------------------#
# The largest group is rental, which suggests that significant portion of customer base don't have their own house
# Mortage holders are also nearly as large as rentals indicating that large number of homeowners are still paying off their rent
# The high number of renters and mortgage holders might indicate potential markets for financial products related to home buying or rental insurance
#------------------------------------------------------------------------------------------------------------------------------------------------------#



     

