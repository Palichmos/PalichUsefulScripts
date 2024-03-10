CREATE OR REPLACE FUNCTION adempiere.target_cost_bom_subreport(pProductId              NUMERIC, 
                                                               pProductBomId           NUMERIC, 
                                                               pDate1                  timestamp WITHOUT time ZONE, 
                                                               pDate2                  timestamp WITHOUT time ZONE, 
                                                               pQtyRequiered            NUMERIC, 
                                                               calculateCost           CHARACTER(1), 
                                                               showComponentNextLevel  CHARACTER(1), 
                                                               showVariants            CHARACTER(1), 
                                                               showOnlyFirstLevel      CHARACTER(1))
 RETURNS TABLE(Sel_Product_ID                NUMERIC,
               M_Product_ID                  NUMERIC, 
               ProductName                   CHARACTER VARYING, 
               C_Uom_ID                      NUMERIC, 
               UOMSymbol                     CHARACTER VARYING, 
               M_Product_Category_ID         NUMERIC, 
               Category                      NUMERIC, 
               M_Product_Category_Parent_ID  NUMERIC, 
               ComponentType1                CHARACTER(2), 
               ComponentType2                CHARACTER(2), 
               QtyRequiered1                 NUMERIC, 
               QtyRequiered2                 NUMERIC, 
               Price1                        NUMERIC, 
               Price2                        NUMERIC, 
               sumCost1                      NUMERIC, 
               sumCost2                      NUMERIC, 
               Description1                  CHARACTER VARYING, 
               Description2                  CHARACTER VARYING, 
               QtyRequieredDelta             integer, 
               PriceDelta                    integer)
 LANGUAGE plpgsql
AS $function$

/**
 * @author @kinerix Anna Fadeeva
 * http://palichmos.ru/
 * 
 * This function collects information on all products in a column without a tree
 * just summary data with quantity and cost
 **/

BEGIN 

RETURN QUERY
    
  WITH reportDataAll AS 
       (SELECT f0.*
          FROM target_cost_bom(pProductId,
                               pProductBomId,
                               pDate1,
                               pDate2,
                               pQtyRequiered,
                               calculateCost,
                               showComponentNextLevel,
                               showVariants,
                               showOnlyFirstLevel
                              ) f0
       ),
        reportSumData AS 
       (SELECT ra.Sel_Product_ID,
               p.M_Product_ID,
               (concat(p.name, ' (', p.value, ')'))::CHARACTER VARYING AS ProductName,
               p.C_Uom_ID,
               uom.UOMSymbol,
               p.M_Product_Category_ID,
               ra.Category,
               pc.M_Product_Category_Parent_ID,
               ra.ComponentType1, 
               ra.ComponentType2, 
               sum(COALESCE(ra.QtyRequiered1, 0::NUMERIC)) AS QtyRequiered1,
               sum(COALESCE(ra.QtyRequiered2, 0::NUMERIC)) AS QtyRequiered2,
               ra.Price1,
               ra.Price2,
               round(sum(COALESCE(ra.COST1, 0::NUMERIC)), 5) AS sumCost1,
               round(sum(COALESCE(ra.COST2, 0::NUMERIC)), 5) AS sumCost2,
               ra.Description1,
               ra.Description2
          FROM reportDataAll ra
          LEFT JOIN M_Product p ON ra.M_Productbom_ID = p.M_Product_ID
          LEFT JOIN M_Product_Category pc ON pc.M_Product_Category_ID = p.M_Product_Category_ID
          LEFT JOIN C_Uom uom ON p.C_Uom_ID = uom.C_Uom_ID
         GROUP BY ra.Sel_Product_ID,
                  p.M_Product_ID,
                  p.name,
                  p.C_Uom_ID,
                  uom.UOMSymbol,
                  p.M_Product_Category_ID,
                  ra.Category,
                  pc.M_Product_Category_Parent_ID,
                  ra.ComponentType1, 
                  ra.ComponentType2, 
                  ra.Price1,
                  ra.Price2,
                  ra.Description1,
                  ra.Description2
       )
        SELECT rd.*,
               CASE
                WHEN (rd.QtyRequiered1 <> 0 AND rd.QtyRequiered2 <> 0 AND rd.QtyRequiered1 <> rd.QtyRequiered2)
                THEN 1
                ELSE 0
                 END AS QtyRequieredDelta,
               CASE
                WHEN (rd.Price1 <> 0 AND rd.Price2 <> 0 AND rd.Price1 <> rd.Price2)
                THEN 1
                ELSE 0
                 END AS PriceDelta
          FROM reportSumData rd;

  END;
$function$
;

/*

-- EXAMPLE QUERY

  SELECT rep.M_Product_ID,
         rep.productName,
         rep.uomsymbol,
         rep.Category,
         rep.M_Product_Category_Parent_ID,
         CASE WHEN rep.QtyRequiered1 = 0 THEN NULL ELSE rep.QtyRequiered1 END AS QtyRequiered1,
         CASE WHEN rep.QtyRequiered2 = 0 THEN NULL ELSE rep.QtyRequiered2 END AS QtyRequiered2,
         CASE WHEN rep.sumCost1 = 0 THEN NULL ELSE rep.sumCost1 END AS sumCost1,
         CASE WHEN rep.sumCost2 = 0 THEN NULL ELSE rep.sumCost2 END AS sumCost2,
         rep.Price1,
         rep.Price2,
         rep.description1,
         rep.description2
    FROM target_cost_bom_subreport(1000025, -- selProductId
                                   1000012, -- pProductBomId
                                   '2023-12-15'::timestamp WITHOUT time ZONE, -- pDate1
                                   '2024-02-01'::timestamp WITHOUT time ZONE, -- pDate2
                                   1::NUMERIC, -- pQtyRequiered
                                   'Y'::CHARACTER, -- calculateCost
                                   'Y'::CHARACTER, -- showComponentNextLevel
                                   'N'::CHARACTER, -- showVariants
                                   'N'::CHARACTER -- showOnlyFirstLevel
             ) rep
   --WHERE rep.M_Product_ID = 1000022
   ORDER BY rep.productName;
*/
