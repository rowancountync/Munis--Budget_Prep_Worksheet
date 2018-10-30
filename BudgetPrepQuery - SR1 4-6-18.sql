use mu_live

DECLARE @a_projection_no AS Int
DECLARE @a_org AS Int 
DECLARE @Object AS Int

SET @a_projection_no = 20191
SET @a_org = 1154110
SET @Object = 573000;

WITH PrevYrs_CTE(a_projection_no, a_org, ly2_actual_bal, ly1_actual_bal, cy_memo_bal, cy_est_actual, cy_revised_bud) 

AS (SELECT DISTINCT bd.a_projection_no, 
					glm.a_org, 
					glm.b_ly2_actual_bal, 
					glm.b_ly1_actual_bal, 
					glm.b_cy_memo_bal, 
					glm.b_cy_est_actual, 
					glm.d_cy_revised_bud

	FROM            gl_master AS glm INNER JOIN gl_budget_det AS bd ON glm.a_org = bd.a_org 
				AND glm.a_object = bd.a_object AND glm.a_project = bd.a_project 

	WHERE          (bd.a_projection_no = @a_projection_no) AND (glm.a_org = @a_org)
	)

SELECT			SUM(ly2_actual_bal) AS ly2_actual_bal, 
				SUM(ly1_actual_bal) AS ly1_actual_bal, 
				SUM(cy_memo_bal) AS cy_memo_bal, 
				SUM(cy_est_actual) AS cy_est_actual, 
				SUM(cy_revised_bud) AS cy_revised_bud

FROM            PrevYrs_CTE AS py