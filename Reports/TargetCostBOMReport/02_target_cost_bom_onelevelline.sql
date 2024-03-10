CREATE OR REPLACE FUNCTION adempiere.target_cost_bom_onelevelline(selProductId            NUMERIC, 
                                                                  pProductBomId           NUMERIC, 
                                                                  l1                      target_cost_bom[], 
                                                                  lno                     NUMERIC, 
                                                                  pDate                   timestamp WITHOUT time ZONE, 
                                                                  columnNo                NUMERIC, 
                                                                  showComponentNextLevel  CHARACTER(1), 
                                                                  showVariants            CHARACTER(1), 
                                                                  showOnlyFirstLevel      CHARACTER(1))
 RETURNS TABLE(Sel_Product_ID                NUMERIC, 
               lno_                          NUMERIC, 
               TreeNoParent                  CHARACTER VARYING, 
               M_Product_ID                  NUMERIC, 
               PP_Product_Bom_Parent_ID      NUMERIC,
               QtyRequiered                  NUMERIC, 
               PP_Product_Bom_ID             NUMERIC, 
               PP_Product_BomLine_ID         NUMERIC, 
               PP_Product_BomLine_C_UOM_ID   NUMERIC,
               M_ProductBom_ID               NUMERIC, 
               ProductBomName                CHARACTER VARYING, 
               M_Product_Category_ID         NUMERIC, 
               ComponentType                 CHARACTER(2), 
               QtyBom                        NUMERIC, 
               IsQtyPercentage               CHARACTER(1), 
               BlUomQtyRequieredTo           NUMERIC,
               QtyRequieredTo                NUMERIC,
               ErrorUOMConversion            CHARACTER VARYING)
 LANGUAGE plpgsql
AS $function$

/**
 * @author @kinerix Anna Fadeeva
 * http://palichmos.ru/
 * 
 * Calculation for one Tree Level
 * columnNo - this parameter shows for which date the calculation is made; you can enter two dates in the report parameters
 **/

BEGIN

RETURN QUERY
    
       WITH luarray AS 
            (SELECT * 
               FROM UNNEST(L1) v0
              WHERE CASE 
                      WHEN columnNo = 1
                      THEN COALESCE(v0.QtyRequiered1, 0) <> 0
                      WHEN columnNo = 2
                      THEN COALESCE(v0.QtyRequiered2, 0) <> 0
                      ELSE 1 = 1
                       END
                AND v0.LevelNo = LNo
                AND CASE -- if 'N', then we do not spin up the components, since they are produced in other manufacturing orders, for example in other manufactory.
                     WHEN showComponentNextLevel = 'N'
                      AND LNo > 0
                     THEN CASE 
                           WHEN columnNo = 1
                           THEN v0.ComponentType1 <> 'CO'
                           WHEN columnNo = 2
                           THEN v0.ComponentType2 <> 'CO'
                           ELSE 1 = 1
                            END
                     ELSE 1 = 1
                      END 
                AND CASE -- spin up only to the first level
                     WHEN showOnlyFirstLevel = 'Y'
                     THEN LNo = 0 
                     ELSE 1 = 1
                      END
            )
            SELECT selProductId,
                   LNo+1 AS LNo_, 
                   lu.TreeNo AS TreeNoParent,
                   pb.M_Product_ID, 
                   lu.PP_Product_Bom_ID AS PP_Product_Bom_Parent_ID,
                   (CASE 
                     WHEN columnNo = 1 THEN lu.QtyRequiered1
                     WHEN columnNo = 2 THEN lu.QtyRequiered2
                     ELSE 0
                      END)::NUMERIC,
                   pbl.PP_Product_Bom_ID,
                   pbl.PP_Product_BomLine_ID,
                   pbl.C_UOM_ID, -- PP_Product_BomLine_C_UOM_ID
                   pbl.M_Product_ID AS M_ProductBom_ID,
                   pl.name AS ProductBomName,
                   CASE 
                    WHEN pl.M_Product_Category_ID IS NULL 
                    THEN p.M_Product_Category_ID 
                    ELSE pl.M_Product_Category_ID 
                     END AS M_Product_Category_ID,
                   pbl.ComponentType,
                   CASE 
                    WHEN pbl.IsQtyPercentage = 'Y'
                    THEN pbl.QtyBatch
                    ELSE pbl.QtyBom 
                     END AS QtyBom,
                   pbl.IsQtyPercentage,
                   (CASE 
                     WHEN columnNo = 1
                     THEN CASE 
                           WHEN pbl.IsQtyPercentage = 'Y'
                           THEN pbl.QtyBatch / 100
                           ELSE pbl.QtyBom 
                            END  * lu.QtyRequiered1
                     WHEN columnNo = 2
                     THEN CASE 
                           WHEN pbl.IsQtyPercentage = 'Y'
                           THEN pbl.QtyBatch / 100
                           ELSE pbl.QtyBom 
                            END  * lu.QtyRequiered2
                     ELSE 0 
                      END)::NUMERIC AS BlUomQtyRequieredTo, -- QtyRequiered IN bomLine C_UOM_ID
                   (CASE 
                     WHEN columnNo = 1
                     THEN CASE 
                           WHEN pbl.IsQtyPercentage = 'Y'
                           THEN pbl.QtyBatch / 100
                           ELSE pbl.QtyBom 
                            END  / CASE WHEN pl.c_uom_id <> pbl.c_uom_id THEN COALESCE(uc.MultiplyRate, 1) ELSE 1 END * lu.QtyRequiered1
                     WHEN columnNo = 2
                     THEN CASE 
                           WHEN pbl.IsQtyPercentage = 'Y'
                           THEN pbl.QtyBatch / 100
                           ELSE pbl.QtyBom 
                            END  / CASE WHEN pl.c_uom_id <> pbl.c_uom_id THEN COALESCE(uc.MultiplyRate, 1) ELSE 1 END * lu.QtyRequiered2
                     ELSE 0 
                      END)::NUMERIC AS QtyRequieredTo, -- QtyRequiered IN component C_UOM_ID
                   (CASE 
                     WHEN pl.c_uom_id <> pbl.c_uom_id 
                      AND uc.C_UOM_Conversion_ID IS NULL 
                     THEN 'Error UOMConversion : NOT FOUND'
                     ELSE NULL 
                      END)::CHARACTER VARYING AS ErrorUOMConversion
              FROM PP_Product_Bom pb
              JOIN luarray lu ON lu.M_ProductBom_ID = pb.M_Product_ID 
                             AND pb.IsActive = 'Y'
                             AND CASE 
                                  WHEN LNo = 0
                                   AND COALESCE(pProductBomId, 0) > 0 -- if this is the parameter entry level in the report
                                  THEN pb.PP_Product_Bom_ID = pProductBomId -- then we take the BOM, that was specified in the parameters
                                  ELSE 1=1 -- if the parameter is empty, then below we calculate the BOM by the key
                                   END 
              JOIN M_Product p ON p.M_Product_ID = pb.M_Product_ID 
                              AND CASE 
                                   WHEN LNo > 0 -- if the level is already below the parameter input
                                     OR (LNo = 0 -- or is this the parameter input level
                                         AND COALESCE(pProductBomId, 0) = 0 -- but the BOM is not specified in the parameters
                                        )
                                   THEN p.Value = pb.Value -- then we are looking BOM by key
                                   ELSE 1=1 -- otherwise the conditions above will apply
                                    END 
              JOIN PP_Product_BomLine pbl ON pbl.PP_Product_Bom_ID = pb.PP_Product_Bom_ID 
                                         AND pbl.IsActive = 'Y' 
                                         AND CASE 
                                              WHEN pbl.IsQtyPercentage = 'Y'
                                              THEN pbl.QtyBatch / 100
                                              ELSE pbl.QtyBom 
                                               END <> 0
                                         AND pbl.validfrom <= pDate 
                                         AND COALESCE(pbl.validto, pDate + INTERVAL '100 years') >= pDate
              JOIN M_Product pl ON pbl.M_Product_ID = pl.M_Product_ID
              LEFT JOIN C_UOM_Conversion uc ON uc.M_Product_ID = pbl.M_Product_ID
                                           AND uc.c_uom_id = pl.c_uom_id
                                           AND uc.c_uom_to_id = pbl.c_uom_id
                                           AND uc.isactive = 'Y'
             WHERE CASE 
                    WHEN showVariants = 'N' -- parameter do not show variants
                    THEN pbl.ComponentType <> 'VA' -- do not show variants
                    ELSE 1 = 1
                     END;
                           
  END;
$function$
;

/*

-- EXAMPLE QUERY

SELECT * 
  FROM target_cost_bom_onelevelline(1000024, 1000011, 
                                    (SELECT ARRAY[(SELECT array_agg(array_to_string(ARRAY[(
                                                         1000024, 
                                                         0,
                                                         0, 
                                                         '-00'::CHARACTER VARYING, -- TreeNoParent
                                                         '-01'::CHARACTER VARYING, -- TreeNo
                                                         0::NUMERIC, --- M_Product_ID
                                                         0::NUMERIC, --- PP_Product_Bom_Parent_ID
                                                         1, -- BomQty1
                                                         1, -- BomQty2
                                                         0::NUMERIC,  --- PP_Product_Bom_ID
                                                         0::NUMERIC,  --- PP_Product_BomLine_ID
                                                         1000024,  --- M_ProductBom_ID
                                                         0::NUMERIC, --- M_Product_Category_ID
                                                         ''::CHARACTER VARYING, -- ComponentType1
                                                         ''::CHARACTER VARYING, -- ComponentType2
                                                         1::NUMERIC, -- QtyBom1
                                                         'N', -- IsQtyPercentage1
                                                         1::NUMERIC, -- QtyBom2
                                                         'N', -- IsQtyPercentage2
                                                         0.1::NUMERIC, -- QtyRequiered1
                                                         0::NUMERIC, -- BlUomQtyRequiered1
                                                         (SELECT C_UOM_ID FROM M_Product p WHERE p.M_Product_ID = 1000025), --- QtyRequiered1_C_UOM_ID
                                                         1::NUMERIC, -- QtyRequiered2
                                                         1::NUMERIC, -- BlUomQtyRequiered2
                                                         (SELECT C_UOM_ID FROM M_Product p WHERE p.M_Product_ID = 1000025), --- QtyRequiered1_C_UOM_ID
                                                         0::NUMERIC, --- Price1
                                                         0::NUMERIC, --- Price2
                                                         0::NUMERIC, --- Cost1
                                                         0::NUMERIC, --- Cost2
                                                         NULL, -- Description1
                                                         NULL, -- Description2
                                                         0::NUMERIC, -- deltaCost,
                                                         0::NUMERIC, -- deltaQty,
                                                         0::NUMERIC, -- deltaPrice,
                                                         0::NUMERIC, -- effectQtyCost,
                                                         0::NUMERIC, -- effectPriceCost,
                                                         0::NUMERIC, -- effectQtyCostPersent,
                                                         0::NUMERIC, -- effectPriceCostPersent,
                                                         0::NUMERIC, -- checker1,
                                                         0::NUMERIC -- checker2
                                                         )]::target_cost_bom[], ', '))
                                                         )]::target_cost_bom[]
                                    ),
                                    0::NUMERIC,
                                    '2023-12-20'::timestamp WITHOUT time ZONE,
                                    1::NUMERIC,
                                    'Y', -- showComponentNextLevel
                                    'N', -- showVariants
                                    'N' -- showOnlyFirstLevel
                                 );
*/


