CREATE OR REPLACE FUNCTION adempiere.statistics_process_call(clientId NUMERIC)
 RETURNS TABLE(dataName CHARACTER VARYING,
               ad_process_id NUMERIC,
               processName CHARACTER VARYING,
               processNameTrl CHARACTER VARYING,
               countCall NUMERIC,
               workflow_Name CHARACTER VARYING,
               wfnodes CHARACTER VARYING,
               schedulersName CHARACTER VARYING,
               isreport CHARACTER VARYING,
               ReportViewName CHARACTER VARYING,
               JasperReport CHARACTER VARYING)
 LANGUAGE plpgsql
AS $function$

/**
 * @PalichMos
 * @author @kinerix Anna Fadeeva
 * */

DECLARE langCode      CHARACTER VARYING;
        processName   CHARACTER VARYING;
        nodeName      CHARACTER VARYING;

BEGIN

SELECT cl.ad_language
  INTO langCode
  FROM ad_client cl
 WHERE cl.ad_client_id = clientId;

SELECT et.name
  INTO processName
  FROM ad_element e
  JOIN ad_element_trl et ON et.ad_element_id = e.ad_element_id
                        AND et.ad_language = langCode
 WHERE e.columnname = 'AD_Process_ID';

SELECT et.name
  INTO nodeName
  FROM ad_element e
  JOIN ad_element_trl et ON et.ad_element_id = e.ad_element_id
                        AND et.ad_language = langCode
 WHERE e.columnname = 'AD_WF_Node_ID';

RETURN QUERY

WITH cntProcesses AS
 (SELECT p.ad_process_id,
         count(p.ad_pinstance_id) AS cnt
    FROM ad_pinstance p
   WHERE p.ad_client_id = clientId
     AND p.created >= now() - INTERVAL '1 week'
     AND p.created < now()::date
   GROUP BY p.ad_process_id
 ),
 cntProcessesAll AS
 (SELECT cp.ad_process_id,
         p.value AS processValue,
         p.name AS processName,
         pt.name AS processNameTrl,
         cp.cnt,
         sum(cp.cnt) OVER (PARTITION BY cp.ad_process_id) AS ntAll,
         p.Classname,
         p.ProcedureName,
         wf.value AS workflow_Value,
         wf.name AS workflow_Name,
         wd.wfnodes,
         sc.schedulersName,
         p.isreport,
         rv.name AS ReportViewName,
         pf.name AS PrintFormat,
         p.JasperReport
    FROM cntProcesses cp
    JOIN ad_process p ON p.ad_process_id = cp.ad_process_id
    JOIN ad_process_trl pt ON pt.ad_process_id = p.ad_process_id
                          AND pt.ad_language = langCode
    LEFT JOIN AD_Workflow wf ON wf.ad_workflow_id = p.AD_Workflow_ID
    LEFT JOIN AD_ReportView rv ON rv.ad_reportview_id = p.AD_ReportView_ID
    LEFT JOIN AD_PrintFormat pf ON pf.ad_printformat_id = p.ad_printformat_id
    LEFT JOIN (SELECT s.ad_process_id,
                      array_to_string(array_agg(s.name), ', '|| chr(10)) AS schedulersName
                 FROM ad_scheduler s
                WHERE s.isactive = 'Y'
                  AND s.name NOT LIKE '%Housekeeping%'
                GROUP BY s.ad_process_id) sc ON sc.ad_process_id = cp.ad_process_id
    LEFT JOIN (WITH bprocesses AS
                 (SELECT wn.ad_process_id,
                         concat(processName||': '||wh.name, chr(10), array_to_string(array_agg(nodeName||': '||wn.name), ','||chr(10) )) AS workflowNodes
                    FROM AD_WF_Node wn
                    JOIN ad_workflow wh ON wh.ad_workflow_id = wn.ad_workflow_id
                   WHERE wn.ad_process_id IS NOT NULL
                   GROUP BY wn.ad_process_id,
                            wh.name
                 )
                  SELECT bs.ad_process_id,
                         array_to_string(array_agg(bs.workflowNodes), ','||chr(10) ) AS wfnodes
                    FROM bprocesses bs
                   GROUP BY bs.ad_process_id
              ) wd ON wd.ad_process_id = cp.ad_process_id
  )
   SELECT (concat('AD_Process_ID = ', cl.ad_process_id, ', ', cl.processName,  ' (',
                  COALESCE(COALESCE(COALESCE('WF='||cl.workflow_Name, 'WfNode='||cl.wfnodes::CHARACTER VARYING), 'schdlr='||cl.schedulersName::CHARACTER VARYING), cl.processNameTrl),
                  ')'
                 ))::CHARACTER VARYING AS dataName,
          cl.ad_process_id,
          cl.processName,
          cl.processNameTrl,
          cl.ntAll AS "За период",
          cl.workflow_Name,
          cl.wfnodes::CHARACTER VARYING,
          cl.schedulersName::CHARACTER VARYING,
          cl.isreport::CHARACTER VARYING,
          cl.ReportViewName,
          cl.JasperReport
     FROM cntProcessesAll cl
    WHERE cl.cnt > 1
    ORDER BY cl.ntAll DESC;

  END;

$function$;
