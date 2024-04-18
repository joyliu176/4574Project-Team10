SELECT 
    j.Employee_id,
    j.Name,
    j.Title,
    j.City,
    j.Address,
    j.hire_date,
    j.annual_salary,
    q.Quit_date
FROM {{ ref('base_google_drive__hr_joins') }} j
LEFT JOIN {{ ref('base_google_drive__hr_quits') }} q 
ON j.Employee_id = q.Employee_id



