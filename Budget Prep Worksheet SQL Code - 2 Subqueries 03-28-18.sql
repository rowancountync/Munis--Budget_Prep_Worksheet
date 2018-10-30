USE mu_live
DECLARE @ProjectionNbr AS Int
DECLARE @Organization AS Int
DECLARE @Object AS Int

SET @ProjectionNbr = 20191
SET @Organization = 1154134
SET @Object = 573000


SELECT DISTINCT  
     (CASE WHEN LEFT(glm.a_org, 3) = '114' THEN ' REV' WHEN LEFT(glm.a_org, 3) = '115' THEN 'EXP' ELSE 'OTH' END) AS RevExp, 
	 bd.a_projection_no, 
	 glm.a_org, 
	 glm.a_object, 
	 glm.a_project, 
     glm.a_account_desc, 
	 glm.b_ly2_actual_bal, 
	 glm.b_ly1_actual_bal, 
	 glm.b_cy_memo_bal, 
	 glm.b_cy_est_actual, 
	 glm.d_cy_revised_bud, 
	 
	 (SELECT SUM(bd1.db_bud_req_amt1) as db_bud_req_amt1   
	 FROM gl_master AS glm1 INNER JOIN gl_budget_det AS bd1 ON glm1.a_org = bd1.a_org AND glm1.a_object = bd1.a_object AND glm1.a_project = bd1.a_project
	 WHERE (bd1.a_projection_no = bd.a_projection_no) AND (glm1.a_org = glm.a_org) AND (glm1.a_object = glm.a_object) AND (bd1.db_bud_req_amt1 <> 0)) AS db_bud_req_amt1,
	 
	 (SELECT SUM(bd2.db_bud_req_amt2) AS db_bud_req_amt2
	 FROM gl_master AS glm2 INNER JOIN gl_budget_det AS bd2 ON glm2.a_org = bd2.a_org AND glm2.a_object = bd2.a_object AND glm2.a_project = bd2.a_project
	 WHERE (bd2.a_projection_no = bd.a_projection_no) AND (glm2.a_org = glm.a_org) AND (glm2.a_object = glm.a_object) AND (bd2.db_bud_req_amt1 <> 0)) AS db_bud_req_amt2,
	 
	 glm.d_bud_cy_level2,
	 bd.TextValueJ, 
	 bd.TextValueD
FROM 
	 gl_master AS glm INNER JOIN
     gl_budget_det AS bd ON glm.a_org = bd.a_org AND glm.a_object = bd.a_object AND glm.a_project = bd.a_project
WHERE        
	(bd.a_projection_no IN (@ProjectionNbr)) AND (glm.a_org IN (@Organization)) AND (glm.a_object IN (@Object)) AND db_bud_req_amt1 <> 0
ORDER BY RevExp, a_projection_no, a_org, a_object