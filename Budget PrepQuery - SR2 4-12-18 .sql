-- FINAL VERSION OF THE BUDGET PREPARATION PREVIOUS YEARS SUBROUTINE 2

use mu_live

DECLARE @a_projection_no AS Int
DECLARE @a_org AS Int 
DECLARE @Object AS Int
DECLARE @RevExp AS Char(4) -- CHAR(4), OR (3) OR WHATEVER, IS REQUIRED IN SSMS FOR THIS QUERY TO RUN PROPERLY

SET @a_projection_no = 20191
SET @a_org = 1144160
SET @Object = 573000
SET @RevExp = ' REV';

-- TWO CTE'S BACK TO BACK WHERE THE SECOND REFERENCES THE DATASET CREATED BY THE FIRST:

WITH RevExp_CTE 
AS (SELECT DISTINCT a_org, 
					(CASE WHEN LEFT(glm1.a_org, 3) = '114' THEN 'REV' WHEN LEFT(glm1.a_org, 3) = '115' THEN 'EXP' ELSE 'OTH' END) AS RevExp
    FROM            gl_master AS glm1), 
	
PrevYrs_CTE(a_projection_no, RevExp, a_org, ly2_actual_bal, ly1_actual_bal, cy_memo_bal, cy_est_actual, cy_revised_bud) AS
    (SELECT DISTINCT	bd.a_projection_no, 
						re.RevExp, 
						glm2.a_org, 
						glm2.b_ly2_actual_bal, 
						glm2.b_ly1_actual_bal, 
						glm2.b_cy_memo_bal, 
						glm2.b_cy_est_actual, 
						glm2.d_cy_revised_bud
     FROM				gl_master AS glm2 
						INNER JOIN gl_budget_det AS bd ON glm2.a_org = bd.a_org AND glm2.a_object = bd.a_object AND glm2.a_project = bd.a_project 
						INNER JOIN RevExp_CTE AS re ON re.a_org = glm2.a_org
     WHERE			    (bd.a_projection_no = @a_projection_no) AND (glm2.a_org IN (@a_org)) AND ((CASE WHEN re.RevExp = 'REV' THEN ' REV' WHEN re.RevExp = 'EXP' THEN 'EXP' ELSE 'OTH' END) IN (@RevExp)))

-- MAIN QUERY REFERENCES SECOND CTE:

SELECT		SUM(ly2_actual_bal) AS ly2_actual_bal, 
			SUM(ly1_actual_bal) AS ly1_actual_bal, 
			SUM(cy_memo_bal) AS cy_memo_bal, 
			SUM(cy_est_actual) AS cy_est_actual, 
			SUM(cy_revised_bud) AS cy_revised_bud
FROM        PrevYrs_CTE AS py