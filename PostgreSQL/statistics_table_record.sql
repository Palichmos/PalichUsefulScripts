CREATE OR REPLACE FUNCTION statistics_table_record(clientId NUMERIC)
RETURNS TABLE (tablename CHARACTER VARYING,
               created date,
               countRecord NUMERIC)
LANGUAGE plpgsql
AS $function$

/**
 * @PalichMos
 * @author @kinerix Anna Fadeeva
 * Using the table record statistics, you can determine which of table are the most critical. These tables and documents on these tables must be the first tested before upgrade iDempiere.
 * */

DECLARE langCode CHARACTER VARYING;

BEGIN

SELECT cl.ad_language
  INTO langCode
  FROM ad_client cl
 WHERE cl.ad_client_id = clientId;

RETURN QUERY

WITH statisticData AS
(
-- movements
  SELECT tr.name AS tablename,
         m.created::date,
         count(*) AS cnt
    FROM m_movement m
    JOIN ad_table t ON upper(t.tablename) = upper('M_Movement')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE m.ad_client_id = clientId
     AND m.created::date >= current_date - INTERVAL '1 week'
     AND m.created::date <> now()::date
     AND m.docstatus IN ('CO', 'CL')
   GROUP BY tr.name,
            m.created::date

UNION ALL
-- purchase orders
  SELECT tr.name||' issotrx = N' AS tablename,
         o.created::date,
         count(*)
    FROM c_order o
    JOIN ad_table t ON upper(t.tablename) = upper('C_Order')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE o.ad_client_id = clientId
     AND o.created::date >= current_date - INTERVAL '1 week'
     AND o.created::date <> now()::date
     AND o.docstatus IN ('IP', 'CO', 'CL')
     AND o.issotrx = 'N'
   GROUP BY tr.name,
            o.created::date

UNION ALL
-- sales orders
  SELECT tr.name||' issotrx = Y' AS tablename,
         o.created::date,
         count(*)
    FROM c_order o
    JOIN ad_table t ON upper(t.tablename) = upper('C_Order')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE o.ad_client_id = clientId
     AND o.created::date >= current_date - INTERVAL '1 week'
     AND o.created::date <> now()::date
     AND o.docstatus IN ('IP', 'CO', 'CL')
     AND o.issotrx = 'Y'
   GROUP BY tr.name,
            o.created::date

UNION ALL
-- m_inout in
  SELECT 'material receipt' AS tablename,
         i.created::date,
         count(*)
    FROM M_InOut i
    JOIN ad_table t ON upper(t.tablename) = upper('M_InOut')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE i.ad_client_id = clientId
     AND i.created::date >= current_date - INTERVAL '1 week'
     AND i.created::date <> now()::date
     AND i.docstatus IN ('IP', 'CO', 'CL')
     AND i.issotrx = 'N'
   GROUP BY tr.name,
            i.created::date

UNION ALL
-- m_rma
  SELECT tr.name AS tablename,
         i.created::date,
         count(*)
    FROM m_rma i
    JOIN ad_table t ON upper(t.tablename) = upper('M_RMA')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE i.ad_client_id = clientId
     AND i.created::date >= current_date - INTERVAL '1 week'
     AND i.created::date <> now()::date
     AND i.docstatus IN ('IP', 'CO', 'CL')
     AND i.issotrx = 'N'
   GROUP BY tr.name,
            i.created::date
UNION ALL
-- m_production
  SELECT 'production' AS tablename,
         i.created::date,
         count(*)
    FROM m_production i
    JOIN ad_table t ON upper(t.tablename) = upper('M_Production')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE i.ad_client_id = clientId
     AND i.created::date >= current_date - INTERVAL '1 week'
     AND i.created::date <> now()::date
     AND i.docstatus IN ('IP', 'CO', 'CL')
   GROUP BY tr.name,
            i.created::date

UNION ALL
-- m_inout shipments
  SELECT 'shipment' AS tablename,
         i.created::date,
         count(*)
    FROM M_InOut i
    JOIN ad_table t ON upper(t.tablename) = upper('M_InOut')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE i.ad_client_id = clientId
     AND i.created::date >= current_date - INTERVAL '1 week'
     AND i.created::date <> now()::date
     AND i.docstatus IN ('IP', 'CO', 'CL')
     AND i.issotrx = 'Y'
   GROUP BY tr.name,
            i.created::date

UNION ALL
-- c_invoice in
  SELECT tr.name||' (+)' AS tablename,
         i.created::date,
         count(*)
    FROM c_invoice i
    JOIN ad_table t ON upper(t.tablename) = upper('C_Invoice')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE i.ad_client_id = clientId
     AND i.created::date >= current_date - INTERVAL '1 week'
     AND i.created::date <> now()::date
     AND i.docstatus IN ('IP', 'CO', 'CL')
     AND i.issotrx = 'N'
   GROUP BY tr.name,
            i.created::date

UNION ALL
-- c_invoice out
  SELECT tr.name||' (-)' AS tablename,
         i.created::date,
         count(*)
    FROM c_invoice i
    JOIN ad_table t ON upper(t.tablename) = upper('C_Invoice')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE i.ad_client_id = clientId
     AND i.created::date >= current_date - INTERVAL '1 week'
     AND i.created::date <> now()::date
     AND i.docstatus IN ('IP', 'CO', 'CL')
     AND i.issotrx = 'Y'
   GROUP BY tr.name,
            i.created::date

UNION ALL
-- payments
  SELECT tr.name AS tablename,
         p.created::date,
         count(*)
    FROM c_payment p
    JOIN ad_table t ON upper(t.tablename) = upper('C_Payment')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE p.ad_client_id = clientId
     AND p.created::date >= current_date - INTERVAL '1 week'
     AND p.created::date <> now()::date
     AND p.docstatus IN ('CO', 'CL')
   GROUP BY tr.name,
            p.created::date

UNION ALL
-- c_bankstatement
  SELECT tr.name AS tablename,
         b.created::date,
         count(*)
    FROM c_bankstatement b
    JOIN ad_table t ON upper(t.tablename) = upper('C_BankStatement')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE b.ad_client_id = clientId
     AND b.created::date >= current_date - INTERVAL '1 week'
     AND b.created::date <> now()::date
     AND b.docstatus IN ('IP', 'CO', 'CL')
   GROUP BY tr.name,
            b.created::date

UNION ALL
-- c_paymentallocate
  SELECT tr.name AS tablename,
         a.created::date,
         count(*)
    FROM c_paymentallocate a
    JOIN ad_table t ON upper(t.tablename) = upper('C_PaymentAllocate')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE a.ad_client_id = clientId
     AND a.created::date >= current_date - INTERVAL '1 week'
     AND a.created::date <> now()::date
   GROUP BY tr.name,
            a.created::date

UNION ALL
  SELECT tr.name AS tablename,
         a.created::date,
         count(*)
    FROM c_allocationhdr a
    JOIN ad_table t ON upper(t.tablename) = upper('C_AllocationHdr')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE a.ad_client_id = clientId
     AND a.created::date >= current_date - INTERVAL '1 week'
     AND a.created::date <> now()::date
   GROUP BY tr.name,
            a.created::date

UNION ALL
-- m_inventory
  SELECT tr.name AS tablename,
         i.created::date,
         count(*)
    FROM m_inventory i
    JOIN ad_table t ON upper(t.tablename) = upper('M_Inventory')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE i.ad_client_id = clientId
     AND i.created::date >= current_date - INTERVAL '1 week'
     AND i.created::date <> now()::date
     AND i.docstatus IN ('CO', 'CL')
   GROUP BY tr.name,
            i.created::date

UNION ALL
-- manufacturing orders
  SELECT tr.name AS tablename,
         p.created::date,
         count(*)
    FROM pp_order p
    JOIN ad_table t ON upper(t.tablename) = upper('PP_Order')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE p.ad_client_id = clientId
     AND p.created::date >= current_date - INTERVAL '1 week'
     AND p.created::date <> now()::date
     AND p.docstatus IN ('CO', 'CL')
   GROUP BY tr.name,
            p.created::date

UNION ALL
-- pp_cost_collector
  SELECT tr.name AS tablename,
         p.created::date,
         count(*)
    FROM pp_cost_collector p
    JOIN ad_table t ON upper(t.tablename) = upper('PP_Cost_Collector')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE p.ad_client_id = clientId
     AND p.created::date >= current_date - INTERVAL '1 week'
     AND p.created::date <> now()::date
     AND p.docstatus IN ('CO', 'CL')
   GROUP BY tr.name,
            p.created::date

UNION ALL
-- pp_product_bomline
  SELECT tr.name||' (create&update)' AS tablename,
         p.updated::date,
         count(*)
    FROM pp_product_bomline p
    JOIN ad_table t ON upper(t.tablename) = upper('PP_Product_BomLine')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE p.ad_client_id = clientId
     AND p.updated::date >= current_date - INTERVAL '1 week'
     AND p.created::date <> now()::date
   GROUP BY tr.name,
            p.updated::date

UNION ALL
-- m_attributesetinstance
  SELECT tr.name AS tablename,
         p.created::date,
         count(*)
    FROM m_attributesetinstance p
    JOIN ad_table t ON upper(t.tablename) = upper('M_AttributeSetInstance')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE p.ad_client_id = clientId
     AND p.created::date >= current_date - INTERVAL '1 week'
     AND p.created::date <> now()::date
   GROUP BY tr.name,
            p.created::date

UNION ALL
-- AD_WF_Process
  SELECT tr.name AS tablename,
         p.created::date,
         count(*)
    FROM AD_WF_Process p
    JOIN ad_table t ON upper(t.tablename) = upper('AD_WF_Process')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE p.ad_client_id = clientId
     AND p.created::date >= current_date - INTERVAL '1 week'
     AND p.created::date <> now()::date
   GROUP BY tr.name,
            p.created::date

UNION ALL
-- fact_acct_summary
  SELECT tr.name AS tablename,
         p.created::date,
         count(*)
    FROM fact_acct_summary p
    JOIN ad_table t ON upper(t.tablename) = upper('Fact_Acct_Summary')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE p.ad_client_id = clientId
     AND p.created::date >= current_date - INTERVAL '1 week'
     AND p.created::date <> now()::date
   GROUP BY tr.name,
            p.created::date

UNION ALL
-- pp_mrp
  SELECT tr.name AS tablename,
         p.created::date,
         count(*)
    FROM pp_mrp p
    JOIN ad_table t ON upper(t.tablename) = upper('PP_MRP')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE p.ad_client_id = clientId
     AND p.created::date >= current_date - INTERVAL '1 week'
     AND p.created::date <> now()::date
   GROUP BY tr.name,
            p.created::date

UNION ALL
-- gl_journal
  SELECT tr.name AS tablename,
         p.created::date,
         count(*)
    FROM gl_journal p
    JOIN ad_table t ON upper(t.tablename) = upper('Gl_Journal')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE p.ad_client_id = clientId
     AND p.created::date >= current_date - INTERVAL '1 week'
     AND p.created::date <> now()::date
   GROUP BY tr.name,
            p.created::date

UNION ALL
-- r_request
  SELECT tr.name AS tablename,
         p.created::date,
         count(*)
    FROM r_request p
    JOIN ad_table t ON upper(t.tablename) = upper('R_Request')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE p.ad_client_id = clientId
     AND p.created::date >= current_date - INTERVAL '1 week'
     AND p.created::date <> now()::date
   GROUP BY tr.name,
            p.created::date

UNION ALL
-- ad_user
  SELECT tr.name AS tablename,
         p.created::date,
         count(*)
    FROM ad_user p
    JOIN ad_table t ON upper(t.tablename) = upper('Ad_User')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE p.ad_client_id = clientId
     AND p.created::date >= current_date - INTERVAL '1 week'
     AND p.created::date <> now()::date
   GROUP BY tr.name,
            p.created::date

UNION ALL
-- c_bpartner
  SELECT tr.name AS tablename,
         p.created::date,
         count(*)
    FROM c_bpartner p
    JOIN ad_table t ON upper(t.tablename) = upper('C_Bpartner')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE p.ad_client_id = clientId
     AND p.created::date >= current_date - INTERVAL '1 week'
     AND p.created::date <> now()::date
   GROUP BY tr.name,
            p.created::date

UNION ALL
-- c_bpartner_location
  SELECT tr.name AS tablename,
         p.created::date,
         count(*)
    FROM c_bpartner_location p
    JOIN ad_table t ON upper(t.tablename) = upper('C_Bpartner_Location')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE p.ad_client_id = clientId
     AND p.created::date >= current_date - INTERVAL '1 week'
     AND p.created::date <> now()::date
   GROUP BY tr.name,
            p.created::date

UNION ALL
-- m_product
  SELECT tr.name AS tablename,
         p.created::date,
         count(*)
    FROM m_product p
    JOIN ad_table t ON upper(t.tablename) = upper('M_Product')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE p.ad_client_id = clientId
     AND p.created::date >= current_date - INTERVAL '1 week'
     AND p.created::date <> now()::date
   GROUP BY tr.name,
            p.created::date

UNION ALL
-- pp_product_planning
  SELECT tr.name AS tablename,
         p.created::date,
         count(*)
    FROM pp_product_planning p
    JOIN ad_table t ON upper(t.tablename) = upper('PP_Product_Planning')
    JOIN ad_table_trl tr ON tr.ad_table_id = t.ad_table_id
                        AND tr.ad_language = langCode
   WHERE p.ad_client_id = clientId
     AND p.created::date >= current_date - INTERVAL '1 week'
     AND p.created::date <> now()::date
   GROUP BY tr.name,
            p.created::date
)
SELECT sd.tablename::CHARACTER VARYING AS tablename,
       sd.created,
       COALESCE(sd.cnt, 0) AS cnt
  FROM statisticData sd
 WHERE sd.created <> now()::date
 UNION ALL
SELECT sd.tablename::CHARACTER VARYING AS tablename,
       (to_char(now(), 'dd.mm.yyyy'))::date AS created,
       round((sum(COALESCE(sd.cnt, 0)::NUMERIC) OVER (PARTITION BY sd.tablename) / sum(COALESCE(sd.cnt, 0)::NUMERIC) OVER()) * 100, 2)::NUMERIC AS cnt
  FROM statisticData sd;

  END;

$function$;


CREATE OR REPLACE VIEW statistics_table_record_v
AS
SELECT c.ad_client_id,
       c.name AS clientName,
       ct.*
  FROM ad_client c,
       crosstab(
       'SELECT tablename,
               (to_char(created, ''dd.mm.yyyy''))::CHARACTER VARYING AS created,
               countRecord
          FROM statistics_table_record('||c.ad_client_id||')
         ORDER BY tablename,
                  created DESC',
       'SELECT (to_char(intervalDate, ''dd.mm.yyyy''))::CHARACTER VARYING
          FROM generate_series(now()::date - INTERVAL ''1 week'',
                               now()::date,
                               ''1 day''::INTERVAL) intervalDate
         ORDER BY intervalDate DESC')
    AS ct (tablename CHARACTER VARYING,
           "Percent" NUMERIC,
           "Yesterday" NUMERIC,
           "Day before Yesterday" NUMERIC,
           "2 days ago" NUMERIC,
           "3 days ago" NUMERIC,
           "4 days ago" NUMERIC,
           "5 days ago" NUMERIC,
           "6 days ago" NUMERIC)
 ORDER BY c.ad_client_id, "Percent" DESC;
COMMENT ON VIEW statistics_table_record_v IS '@PalichMos, @author @kinerix Anna Fadeeva
Using the table record statistics, you can determine which of table are the most critical. These tables and documents on these tables must be the first tested before upgrade iDempiere.';
