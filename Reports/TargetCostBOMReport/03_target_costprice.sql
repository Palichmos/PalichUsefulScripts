CREATE OR REPLACE FUNCTION adempiere.target_costprice(pproductid numeric, pdate timestamp without time zone)
 RETURNS TABLE(costprice numeric, description character varying)
 LANGUAGE plpgsql
AS $function$

/**
 * @author @kinerix Anna Fadeeva
 * http://palichmos.ru/
 * 
 * The function determines the price or cost of product. 
 * You can change this algorithm for you.
 **/

DECLARE costCelevaya          NUMERIC := 0;
        requestDocumentNo     CHARACTER VARYING;
        orderDocumentNo       CHARACTER VARYING;
        inOutDescr            CHARACTER VARYING;
        maxCostPriceDate      timestamp WITHOUT time ZONE;
        pPriceListId          NUMERIC := 101; /* Standard */
   
BEGIN
    
  IF pDate IS NULL
THEN 
     RETURN QUERY 
            SELECT 0::NUMERIC,
                   NULL::CHARACTER VARYING;
ELSE

-- Level 0
WITH sql_cost AS 
     (SELECT pp.m_product_id, 
             pp.pricelist, 
             plv.validfrom, 
             (lag(plv.validfrom - INTERVAL '1 day') OVER (PARTITION BY pp.m_product_id, 
                                                                       plv.m_pricelist_id 
                                                              ORDER BY plv.m_pricelist_id, 
                                                                       pp.m_product_id, 
                                                                       plv.validfrom DESC)
             ) AS validTo
        FROM m_productprice pp 
        JOIN m_pricelist_version plv ON plv.m_pricelist_version_id = pp.m_pricelist_version_id
                                    AND plv.isactive = 'Y'
       WHERE plv.m_pricelist_id = pPriceListId
         AND pp.m_product_id = pProductId
     )
      SELECT max(sc.pricelist)
        INTO costCelevaya
        FROM sql_cost sc
       WHERE pDate BETWEEN sc.validfrom AND COALESCE(sc.validTo, pDate + INTERVAL '1 month');

          -- Level 1
          IF COALESCE(costCelevaya, 0) = 0
        THEN -- NEXT query FOR determine cost
             SELECT 0::NUMERIC,
                    NULL AS documentno,
                    NULL AS documentno
               INTO costCelevaya,
                    requestDocumentNo,
                    orderDocumentNo;
         
                 -- Level 2
                 IF COALESCE(costCelevaya, 0) = 0
               THEN -- NEXT query FOR determine cost
                    SELECT 0::NUMERIC,
                           NULL AS orderDocNo
                      INTO costCelevaya,
                           orderDocumentNo;

                        -- Level 3
                        IF COALESCE(costCelevaya, 0) = 0
                      THEN -- NEXT query FOR determine cost
                           SELECT 0::NUMERIC,
                                  NULL AS description
                             INTO costCelevaya,
                                  inOutDescr;
                    
                               -- Level 4
                               IF COALESCE(costCelevaya, 0) = 0
                             THEN -- NEXT query FOR determine cost
                                  RETURN QUERY
                                         SELECT sum(COALESCE(t.currentcostprice, 0)),
                                                'Any descr for your formula'::CHARACTER VARYING
                                           FROM m_cost t
                                          WHERE t.m_product_id = pProductId;
                             ELSE 
                                  RETURN QUERY -- Level 3
                                  SELECT costCelevaya,
                                         inOutDescr;
                              END IF;
                      ELSE -- Level 2 
                           RETURN QUERY 
                           SELECT costCelevaya,
                                  (concat('Any descr for your formula', orderDocumentNo))::CHARACTER VARYING;
                       END IF;
       
               ELSE -- Level 1
                    RETURN QUERY
                           SELECT costCelevaya,
                                  (concat('Any descr for your formula', requestDocumentNo, 
                                           CASE 
                                            WHEN orderDocumentNo IS NOT NULL 
                                            THEN concat(',', chr(10), 'зак. на закуп.№', orderDocumentNo)
                                            ELSE ''
                                             END
                                         )
                                  )::CHARACTER VARYING;
                END IF;
        ELSE -- Level 0
             RETURN QUERY 
                    SELECT costCelevaya,
                           'Standart price'::CHARACTER VARYING;
         END IF;
    
 END IF;

END;

$function$
;

/*
-- EXAMPLE QUERY

SELECT * FROM target_costprice(1000002, now()::timestamp without time ZONE - INTERVAL '1 mon')
*/
