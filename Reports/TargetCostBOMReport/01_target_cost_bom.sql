CREATE OR REPLACE FUNCTION adempiere.target_Cost_bom(selProductId             NUMERIC, 
                                                     pProductBomId            NUMERIC, 
                                                     pDate1                   timestamp WITHOUT time ZONE, 
                                                     pDate2                   timestamp WITHOUT time ZONE, 
                                                     pQtyRequiered            NUMERIC, 
                                                     calculateCost            CHARACTER(1), 
                                                     showComponentNextLevel   CHARACTER(1), 
                                                     showVariants             CHARACTER(1), 
                                                     showOnlyFirstLevel       CHARACTER(1))
 RETURNS TABLE(Sel_Product_ID                NUMERIC, 
               LevelNo                       NUMERIC, 
               Category                      NUMERIC,
               TreeNoParent                  CHARACTER VARYING, 
               TreeNo                        CHARACTER VARYING, 
               M_Product_ID                  NUMERIC, 
               PP_Product_Bom_Parent_ID      NUMERIC, 
               BomQty1                       NUMERIC, 
               BomQty2                       NUMERIC, 
               PP_Product_Bom_ID             NUMERIC, 
               PP_Product_BomLine_ID         NUMERIC,
               M_ProductBom_ID               NUMERIC, 
               M_Product_Category_ID         NUMERIC, 
               ComponentType1                CHARACTER(2), 
               ComponentType2                CHARACTER(2), 
               QtyBom1                       NUMERIC, 
               IsQtyPercentage1              CHARACTER(1),
               QtyBom2                       NUMERIC,
               IsQtyPercentage2              CHARACTER(1),
               QtyRequiered1                 NUMERIC, 
               BlUomQtyRequiered1            NUMERIC,
               BlUom1_C_UOM_ID               NUMERIC,
               QtyRequiered2                 NUMERIC, 
               BlUomQtyRequiered2            NUMERIC, 
               BlUom2_C_UOM_ID               NUMERIC, 
               Price1                        NUMERIC, 
               Price2                        NUMERIC, 
               Cost1                         NUMERIC, 
               Cost2                         NUMERIC, 
               Description1                  CHARACTER VARYING, 
               Description2                  CHARACTER VARYING, 
               DeltaCost                     NUMERIC, 
               DeltaQty                      NUMERIC, 
               DeltaPrice                    NUMERIC, 
               EffectQtyCost                 NUMERIC, 
               EffectPriceCost               NUMERIC, 
               EffectQtyCostPersent          NUMERIC, 
               EffectPriceCostPersent        NUMERIC, 
               checker1                      NUMERIC, 
               checker2                      NUMERIC)
 LANGUAGE plpgsql
AS $function$

/**
 * @author @kinerix Anna Fadeeva
 * http://palichmos.ru/
 * 
 * Target cost report
 **/

/**
 *
  Before need to create custom type in this database
  --DROP TYPE target_Cost_bom;
  CREATE TYPE target_Cost_bom AS 
              (Sel_Product_ID               NUMERIC, 
               LevelNo                      NUMERIC, 
               Category                     NUMERIC,
               TreeNoParent                 CHARACTER VARYING,
               TreeNo                       CHARACTER VARYING,
               M_Product_ID                 NUMERIC, 
               PP_Product_Bom_Parent_ID     NUMERIC,
               BomQty1                      NUMERIC,
               BomQty2                      NUMERIC,
               PP_Product_Bom_ID            NUMERIC,
               PP_Product_BomLine_ID        NUMERIC,
               M_ProductBom_ID              NUMERIC, 
               M_Product_Category_ID        NUMERIC,
               ComponentType1               CHARACTER(2),
               ComponentType2               CHARACTER(2),
               QtyBom1                      NUMERIC, 
               IsQtyPercentage1             CHARACTER(1),
               QtyBom2                      NUMERIC,
               IsQtyPercentage2             CHARACTER(1),
               QtyRequiered1                NUMERIC,
               BlUomQtyRequiered1           NUMERIC,
               BlUom1_C_UOM_ID              NUMERIC,
               QtyRequiered2                NUMERIC,
               BlUomQtyRequiered2           NUMERIC,
               BlUom2_C_UOM_ID              NUMERIC,
               Price1                       NUMERIC,
               Price2                       NUMERIC,
               Cost1                        NUMERIC,
               Cost2                        NUMERIC,
               Description1                 CHARACTER VARYING,
               Description2                 CHARACTER VARYING,
               DeltaCost                    NUMERIC,
               DeltaQty                     NUMERIC,
               DeltaPrice                   NUMERIC,
               EffectQtyCost                NUMERIC,
               EffectPriceCost              NUMERIC,
               EffectQtyCostPersent         NUMERIC,
               EffectPriceCostPersent       NUMERIC,
               checker1                     NUMERIC,
               checker2                     NUMERIC
              );   

  --DROP TYPE target_Cost_bom_ReverseSum;
  CREATE TYPE target_Cost_bom_ReverseSum AS 
              (LevelNo          NUMERIC, 
               Category         NUMERIC,
               TreeNoParent     CHARACTER VARYING,
               TreeNo           CHARACTER VARYING,
               Cost1            NUMERIC,
               Cost2            NUMERIC,
               EffectQtyCost    NUMERIC,
               EffectPriceCost  NUMERIC,
               checker1         NUMERIC
              );   
*/

DECLARE L0                              target_Cost_bom[];
        L1                              target_Cost_bom[];
        L2                              target_Cost_bom[];
        L3                              target_Cost_bom_ReverseSum[];
        L4                              target_Cost_bom_ReverseSum[];
        LNo                             NUMERIC := 0;
        LNo_Cost                        NUMERIC := 0;
        LNo_FA                          NUMERIC := 0;

BEGIN

L0 = (SELECT ARRAY[(SELECT array_agg(array_to_string(ARRAY[(
             selProductId, 
             LNo,
             0::NUMERIC, -- Category
             '-00'::CHARACTER VARYING, -- TreeNoParent
             '-01'::CHARACTER VARYING, -- TreeNo
             0::NUMERIC, --- M_Product_ID
             0::NUMERIC, --- PP_Product_Bom_Parent_ID
             pQtyRequiered, -- BomQty1
             pQtyRequiered, -- BomQty2
             0::NUMERIC,  --- PP_Product_Bom_ID
             0::NUMERIC,  --- PP_Product_BomLine_ID
             selProductId,  --- M_ProductBom_ID
             0::NUMERIC, --- M_Product_Category_ID
             ''::CHARACTER VARYING, -- ComponentType1
             ''::CHARACTER VARYING, -- ComponentType2
             1::NUMERIC, -- QtyBom1
             'N', -- IsQtyPercentage1
             1::NUMERIC, -- QtyBom2
             'N', -- IsQtyPercentage2
             pQtyRequiered, -- QtyRequiered1
             pQtyRequiered, -- BlUomQtyRequiered1
             (SELECT C_UOM_ID FROM M_Product p WHERE p.M_Product_ID = selProductId), --- BlUom1_C_UOM_ID
             pQtyRequiered, -- QtyRequiered2
             pQtyRequiered, -- BlUomQtyRequiered2
             (SELECT C_UOM_ID FROM M_Product p WHERE p.M_Product_ID = selProductId), --- BlUom2_C_UOM_ID
             0::NUMERIC, --- Price1
             0::NUMERIC, --- Price2
             0::NUMERIC, --- Cost1
             0::NUMERIC, --- Cost2
             NULL, -- Description1
             NULL, -- Description2
             0::NUMERIC, -- DeltaCost
             0::NUMERIC, -- DeltaQty
             0::NUMERIC, -- DeltaPrice
             0::NUMERIC, -- EffectQtyCost
             0::NUMERIC, -- EffectPriceCost
             0::NUMERIC, -- EffectQtyCostPersent
             0::NUMERIC, -- EffectPriceCostPersent
             0::NUMERIC, -- checker1
             0::NUMERIC  -- checker2 
             )]::target_Cost_bom[], ', '))
             )]::target_Cost_bom[]
     );

L1 = L0;
L2 = L0;

/********************************************************BOM & Formula (start of calculation)***************************************************/
LOOP

L1 = (SELECT ARRAY[(SELECT array_agg(array_to_string(ARRAY[(
             g0.Sel_Product_ID,
             g0.LevelNo,
             2::NUMERIC, -- Category
             g0.TreeNoParent,
             g0.TreeNo,
             g0.M_Product_ID, 
             g0.PP_Product_Bom_Parent_ID,
             g0.BomQty1,
             g0.BomQty2,
             g0.PP_Product_Bom_ID,
             g0.PP_Product_BomLine_ID,
             g0.M_ProductBom_ID,
             g0.M_Product_Category_ID,
             g0.ComponentType1,
             g0.ComponentType2,
             g0.QtyBom1,
             g0.IsQtyPercentage1,
             g0.QtyBom2,
             g0.IsQtyPercentage2,
             g0.QtyRequiered1,
             g0.BlUomQtyRequiered1,
             g0.BlUom1_C_UOM_ID,
             g0.QtyRequiered2,
             g0.BlUomQtyRequiered2,
             g0.BlUom2_C_UOM_ID,
             g0.Price1,
             g0.Price2,
             g0.Price1 * g0.QtyRequiered1, -- Cost = цена * кол-во
             g0.Price2 * g0.QtyRequiered2,
             g0.Description1,
             g0.Description2,
             0::NUMERIC, -- DeltaCost
             0::NUMERIC, -- DeltaQty
             0::NUMERIC, -- DeltaPrice
             0::NUMERIC, -- EffectQtyCost
             0::NUMERIC, -- EffectPriceCost
             0::NUMERIC, -- EffectQtyCostPersent
             0::NUMERIC, -- EffectPriceCostPersent
             0::NUMERIC, -- checker1
             0::NUMERIC  -- checker2
             )]::target_Cost_bom[], ', '))
             )]::target_Cost_bom[]
        FROM (SELECT j0.Sel_Product_ID,
                     j0.LNo_ AS LevelNo, 
                     j0.TreeNoParent,
                     j0.TreeNoParent||CASE 
                                       WHEN j0.RowNo < 10 
                                       THEN '-0' 
                                       ELSE '-' 
                                        END||j0.RowNo::CHARACTER VARYING AS TreeNo,
                     j0.M_Product_ID, 
                     j0.PP_Product_Bom_Parent_ID,
                     j0.BomQty1,
                     j0.BomQty2,
                     j0.PP_Product_Bom_ID,
                     j0.PP_Product_BomLine_ID,
                     j0.M_ProductBom_ID,
                     j0.M_Product_Category_ID,
                     j0.ComponentType1,
                     j0.ComponentType2,
                     j0.QtyBom1,
                     j0.IsQtyPercentage1,
                     j0.QtyBom2,
                     j0.IsQtyPercentage2,
                     j0.QtyRequiered1,
                     j0.BlUomQtyRequiered1,
                     j0.BlUom1_C_UOM_ID,
                     j0.QtyRequiered2,
                     j0.BlUomQtyRequiered2,
                     j0.BlUom2_C_UOM_ID,
                     0::NUMERIC AS Price1,
                     0::NUMERIC AS Price2,
                     j0.ErrorUOMConversion1 AS Description1,
                     j0.ErrorUOMConversion2 AS Description2
                FROM (
                        WITH bomLineData1 AS 
                             (SELECT d.Sel_Product_ID,
                                     d.LNo_, 
                                     d.TreeNoParent,
                                     d.M_Product_ID, 
                                     d.PP_Product_Bom_Parent_ID,
                                     d.QtyRequiered,
                                     d.PP_Product_Bom_ID,
                                     d.PP_Product_BomLine_ID,
                                     d.PP_Product_BomLine_C_UOM_ID AS BlUom1_C_UOM_ID,
                                     d.M_ProductBom_ID,
                                     d.ProductBomName,
                                     d.M_Product_Category_ID,
                                     d.ComponentType,
                                     d.QtyBom,
                                     d.IsQtyPercentage,
                                     d.QtyRequieredTo AS QtyRequiered1,
                                     d.ErrorUOMConversion AS ErrorUOMConversion1,
                                     d.BlUomQtyRequieredTo AS BlUomQtyRequiered1
                                FROM target_Cost_bom_onelevelline(selProductId, pProductBomId, L1, LNo, pDate1, 1, showComponentNextLevel, showVariants, showOnlyFirstLevel) d
                             ), 
                             bomLineData2 AS 
                             (SELECT d.Sel_Product_ID,
                                     d.LNo_, 
                                     d.TreeNoParent,
                                     d.M_Product_ID, 
                                     d.PP_Product_Bom_Parent_ID,
                                     d.QtyRequiered,
                                     d.PP_Product_Bom_ID,
                                     d.PP_Product_BomLine_ID,
                                     d.PP_Product_BomLine_C_UOM_ID AS BlUom2_C_UOM_ID,
                                     d.M_ProductBom_ID,
                                     d.ProductBomName,
                                     d.M_Product_Category_ID,
                                     d.ComponentType,
                                     d.QtyBom,
                                     d.IsQtyPercentage,
                                     d.QtyRequieredTo AS QtyRequiered2,
                                     d.ErrorUOMConversion AS ErrorUOMConversion2,
                                     d.BlUomQtyRequieredTo AS BlUomQtyRequiered2
                                FROM target_Cost_bom_onelevelline(selProductId, pProductBomId, L1, LNo, pDate2, 2, showComponentNextLevel, showVariants, showOnlyFirstLevel) d
                             ),
                             bomLines AS
                             (SELECT DISTINCT 
                                     d.Sel_Product_ID,
                                     d.LNo_,
                                     d.TreeNoParent,
                                     d.M_Product_ID,
                                     d.PP_Product_Bom_Parent_ID,
                                     d.PP_Product_Bom_ID,
                                     max(d.PP_Product_BomLine_ID) AS PP_Product_BomLine_ID,
                                     d.M_ProductBom_ID,
                                     d.ProductBomName,
                                     d.M_Product_Category_ID
                                FROM (SELECT d1.Sel_Product_ID,
                                             d1.LNo_,
                                             d1.TreeNoParent,
                                             d1.M_Product_ID,
                                             d1.PP_Product_Bom_Parent_ID,
                                             d1.PP_Product_Bom_ID,
                                             d1.PP_Product_BomLine_ID,
                                             d1.M_ProductBom_ID,
                                             d1.ProductBomName,
                                             d1.M_Product_Category_ID
                                        FROM bomLineData1 d1
                                       UNION ALL 
                                      SELECT d2.Sel_Product_ID,
                                             d2.LNo_,
                                             d2.TreeNoParent,
                                             d2.M_Product_ID,
                                             d2.PP_Product_Bom_Parent_ID,
                                             d2.PP_Product_Bom_ID,
                                             d2.PP_Product_BomLine_ID,
                                             d2.M_ProductBom_ID,
                                             d2.ProductBomName,
                                             d2.M_Product_Category_ID
                                        FROM bomLineData2 d2
                                     ) d
                               GROUP BY d.Sel_Product_ID,
                                        d.LNo_,
                                        d.TreeNoParent,
                                        d.M_Product_ID,
                                        d.PP_Product_Bom_Parent_ID,
                                        d.PP_Product_Bom_ID,
                                        d.M_ProductBom_ID,
                                        d.ProductBomName,
                                        d.M_Product_Category_ID
                             )
                              SELECT bl.Sel_Product_ID,
                                     bl.LNo_,
                                     bl.TreeNoParent,
                                     ROW_NUMBER() OVER (PARTITION BY bl.TreeNoParent ORDER BY bl.ProductBomName) AS RowNo,
                                     bl.M_Product_ID,
                                     bl.PP_Product_Bom_Parent_ID,
                                     COALESCE(d1.QtyRequiered, 0) AS BomQty1, 
                                     COALESCE(d2.QtyRequiered, 0) AS BomQty2,
                                     bl.PP_Product_Bom_ID,
                                     bl.PP_Product_BomLine_ID,
                                     bl.M_ProductBom_ID,
                                     bl.M_Product_Category_ID,
                                     COALESCE(d1.ComponentType, '') AS ComponentType1,
                                     COALESCE(d2.ComponentType, '') AS ComponentType2,
                                     COALESCE(d1.QtyBom, 0) AS QtyBom1,
                                     COALESCE(d1.IsQtyPercentage, NULL::CHARACTER(1)) AS IsQtyPercentage1,
                                     COALESCE(d2.QtyBom, 0) AS QtyBom2,
                                     COALESCE(d2.IsQtyPercentage, NULL::CHARACTER(1)) AS IsQtyPercentage2,
                                     COALESCE(d1.QtyRequiered1, 0) AS QtyRequiered1,
                                     d1.ErrorUOMConversion1,
                                     COALESCE(d1.BlUomQtyRequiered1, 0) AS BlUomQtyRequiered1,
                                     d1.BlUom1_C_UOM_ID,
                                     COALESCE(d2.QtyRequiered2, 0) AS QtyRequiered2,
                                     d2.ErrorUOMConversion2,
                                     COALESCE(d2.BlUomQtyRequiered2, 0) AS BlUomQtyRequiered2,
                                     d2.BlUom2_C_UOM_ID
                                FROM bomLines bl
                                LEFT JOIN bomLineData1 d1 ON d1.TreeNoParent                = bl.TreeNoParent
                                                         AND d1.PP_Product_Bom_ID           = bl.PP_Product_Bom_ID
                                                         AND d1.M_ProductBom_ID             = bl.M_ProductBom_ID
                                LEFT JOIN bomLineData2 d2 ON d2.TreeNoParent                = bl.TreeNoParent
                                                         AND d2.PP_Product_Bom_ID           = bl.PP_Product_Bom_ID
                                                         AND d2.M_ProductBom_ID             = bl.M_ProductBom_ID                         
                     ) j0 
             ) g0
     );

LNo = LNo+1;
-- accumulate the data of each level into one array
L2 = (SELECT ARRAY[(SELECT array_agg(array_to_string(ARRAY[( 
                           L2_t.*
                           )]::target_Cost_bom[], ', '))
                           )]::target_Cost_bom[]
                      FROM (SELECT * FROM UNNEST(L2) t0
                             UNION ALL 
                            SELECT * FROM UNNEST(L1) t1
                           ) L2_t
     );

EXIT WHEN (SELECT count(*)::NUMERIC FROM UNNEST(L1)) = 0::NUMERIC;

END LOOP;
/********************************************************BOM & Formula (end of calculation)****************************************************/

-- set the cost for raw materials
    IF calculateCost = 'Y' -- the cost is recalculated with a positive parameter = 'Y'
  THEN L2 = (WITH products AS 
               (SELECT DISTINCT j0.M_ProductBom_ID
                  FROM UNNEST(L2) j0
                  JOIN m_product p ON p.M_Product_ID = j0.M_ProductBom_ID
                  -- TODO here it is advisable to separate raw materials from semi-finished products, but this is not critical
               ),
               CostPrice_proddata1 AS 
               (SELECT p.M_ProductBom_ID,
                       cp.CostPrice,
                       cp.Description
                  FROM products p,
                       target_CostPrice(p.M_ProductBom_ID, pDate1::timestamp WITHOUT time ZONE) cp
               ),
               CostPrice_proddata2 AS 
               (SELECT p.M_ProductBom_ID,
                       cp.CostPrice,
                       cp.Description
                  FROM products p,
                       target_CostPrice(p.M_ProductBom_ID, pDate2::timestamp WITHOUT time ZONE) cp
               )  
                SELECT ARRAY[(SELECT array_agg(array_to_string(ARRAY[( 
                                     t0.Sel_Product_ID,
                                     t0.LevelNo,
                                     t0.Category,
                                     t0.TreeNoParent,
                                     t0.TreeNo,
                                     t0.M_Product_ID,
                                     t0.PP_Product_Bom_Parent_ID,
                                     t0.BomQty1,
                                     t0.BomQty2,
                                     t0.PP_Product_Bom_ID,
                                     t0.PP_Product_BomLine_ID,
                                     t0.M_ProductBom_ID,
                                     t0.M_Product_Category_ID,
                                     t0.ComponentType1,
                                     t0.ComponentType2,
                                     t0.QtyBom1,
                                     t0.IsQtyPercentage1,
                                     t0.QtyBom2,
                                     t0.IsQtyPercentage2,
                                     t0.QtyRequiered1,
                                     t0.BlUomQtyRequiered1,
                                     t0.BlUom1_C_UOM_ID,
                                     t0.QtyRequiered2,
                                     t0.BlUomQtyRequiered2,
                                     t0.BlUom2_C_UOM_ID,
                                     COALESCE(cp1.CostPrice, t0.Price1), -- Price
                                     COALESCE(cp2.CostPrice, t0.Price2), -- Price
                                     COALESCE(cp1.CostPrice, t0.Price1) * t0.QtyRequiered1, -- Cost
                                     COALESCE(cp2.CostPrice, t0.Price2) * t0.QtyRequiered2, -- Cost
                                     CASE WHEN upper(COALESCE(t0.Description1, '')) LIKE upper('%Error%') THEN t0.Description1 ELSE coalesce(cp1.Description, t0.Description1) END,
                                     CASE WHEN upper(COALESCE(t0.Description2, '')) LIKE upper('%Error%') THEN t0.Description2 ELSE coalesce(cp2.Description, t0.Description2) END,
                                     t0.DeltaCost,
                                     t0.DeltaQty,
                                     t0.DeltaPrice,
                                     t0.EffectQtyCost,
                                     t0.EffectPriceCost,
                                     t0.EffectQtyCostPersent,
                                     t0.EffectPriceCostPersent,
                                     t0.checker1,
                                     t0.checker2
                                     )]::target_Cost_bom[], ', '))
                                     )]::target_Cost_bom[]
                                FROM UNNEST(L2) t0
                                LEFT JOIN CostPrice_proddata1 cp1 ON cp1.M_ProductBom_ID = t0.M_ProductBom_ID
                                LEFT JOIN CostPrice_proddata2 cp2 ON cp2.M_ProductBom_ID = t0.M_ProductBom_ID
            );
   END IF; -- calculateCost = 'Y'
             
L0 = NULL;
L1 = NULL;


L3 = (SELECT ARRAY[(SELECT array_agg(array_to_string(ARRAY[(
             a0.LevelNo, 
             a0.Category,
             a0.TreeNoParent,
             a0.TreeNo,
             a0.Cost1,
             a0.Cost2,
             a0.EffectQtyCost,
             a0.EffectPriceCost,
             a0.checker1
             )]::target_Cost_bom_ReverseSum[], ', '))
             )]::target_Cost_bom_ReverseSum[]
        FROM UNNEST(L2) a0
     );

-- to recalculate the cost of semi-finished products and finished products, need to take all the raw materials and add the cost in reverse order in a circle
-- first calculate the maximum level of nesting that was calculated, this is the raw material, calculate from it

    IF calculateCost = 'Y' -- the cost is recalculated with a positive parameter = 'Y'
  THEN 
        LNo_Cost = (SELECT max(s0.LevelNo) FROM unnest(L3) s0);  
        LOOP
                    /************************************************************/
        -- begin to calculate the cost in reverse order from raw materials to the final product
        
        L4 = (SELECT ARRAY[(SELECT array_agg(array_to_string(ARRAY[(
                     w1.LevelNo,
                     w1.Category,
                     w1.TreeNoParent,  
                     w1.TreeNo,
                     w1.sumCost1,
                     w1.sumCost2,
                     w1.sumEffectQtyCost,
                     w1.sumEffectPriceCost,
                     w1.sumChecker1
                     )]::target_Cost_bom_ReverseSum[], ', '))
                     )]::target_Cost_bom_ReverseSum[]
                FROM (SELECT w0.LevelNo,
                             0::NUMERIC AS Category,
                             w0.TreeNoParent,  
                             ''::CHARACTER VARYING AS TreeNo,
                             sum(w0.Cost1) AS sumCost1,
                             sum(w0.Cost2) AS sumCost2,
                             sum(w0.EffectQtyCost) AS sumEffectQtyCost, -- there are only zeros, these fields are calculated at the end of the calculation
                             sum(w0.EffectPriceCost) AS sumEffectPriceCost, -- there are only zeros, these fields are calculated at the end of the calculation
                             sum(w0.checker1) AS sumChecker1 -- there are only zeros, these fields are calculated at the end of the calculation
                        FROM UNNEST(L3) w0
                       WHERE w0.LevelNo = LNo_Cost
                       GROUP BY w0.LevelNo,
                                w0.TreeNoParent) w1
             );
        -- update prices for all levels    
        L3 = (SELECT ARRAY[(SELECT array_agg(array_to_string(ARRAY[(
                     m0.LevelNo, 
                     m0.Category,
                     m0.TreeNoParent, 
                     m0.TreeNo, 
                     m0.CostNew1,
                     m0.CostNew2,
                     m0.EffectQtyCost,
                     m0.EffectPriceCost,
                     m0.checker1
                     )]::target_Cost_bom_ReverseSum[], ', '))
                     )]::target_Cost_bom_ReverseSum[]
                FROM (SELECT t0.LevelNo, 
                             CASE 
                              WHEN t0.LevelNo > 0 
                               AND t0.LevelNo = LNo_Cost-1
                               AND t1.TreeNoParent IS NOT NULL
                              THEN 1::NUMERIC
                              ELSE t0.Category
                               END AS Category,
                             t0.TreeNoParent, 
                             t0.TreeNo, 
                             CASE
                              WHEN COALESCE(t1.Cost1, 0) > 0
                              THEN t1.Cost1 
                              ELSE t0.Cost1
                               END AS CostNew1, 
                             CASE
                              WHEN COALESCE(t1.Cost2, 0) > 0
                              THEN t1.Cost2 
                              ELSE t0.Cost2
                               END AS CostNew2,
                             t1.EffectQtyCost,
                             t1.EffectPriceCost,
                             t1.checker1
                        FROM UNNEST(L3) t0
                        LEFT JOIN UNNEST(L4) t1 ON t1.TreeNoParent = t0.TreeNo 
                                               AND t0.LevelNo = LNo_Cost-1) m0
             );
        
        LNo_Cost = LNo_Cost - 1;
        
        EXIT WHEN LNo_Cost <= 0;
        
        END LOOP;

/*******************PUTS THE REMAINING COSTS AND PRICES********************/
L2 = (SELECT ARRAY[(SELECT array_agg(array_to_string(ARRAY[( 
              d.Sel_Product_ID, 
              d.LevelNo,
              z.Category,
              d.TreeNoParent,
              d.TreeNo,
              d.M_Product_ID, 
              d.PP_Product_Bom_Parent_ID, 
              d.BomQty1, 
              d.BomQty2,
              d.PP_Product_Bom_ID,
              d.PP_Product_BomLine_ID, 
              d.M_ProductBom_ID,
              d.M_Product_Category_ID,
              d.ComponentType1, 
              d.ComponentType2,
              d.QtyBom1,
              d.IsQtyPercentage1,
              d.QtyBom2,
              d.IsQtyPercentage2,
              d.QtyRequiered1,
              d.BlUomQtyRequiered1,
              d.BlUom1_C_UOM_ID,
              d.QtyRequiered2,
              d.BlUomQtyRequiered2,
              d.BlUom2_C_UOM_ID,
              CASE
               WHEN z.Category IN (0, 1) -- END product OR semi-finished product
                AND d.QtyRequiered1 > 0
                AND d.Price1 = 0
               THEN round(z.Cost1 / d.QtyRequiered1, 2)
               ELSE d.Price1
                END, -- Price1
              CASE
               WHEN z.Category IN (0, 1) -- END product OR semi-finished product
                AND d.QtyRequiered2 > 0
                AND d.Price2 = 0
               THEN round(z.Cost2 / d.QtyRequiered2, 2)
               ELSE d.Price2
                END, -- Price2
              z.Cost1,
              z.Cost2,
              d.Description1,
              d.Description2,
              d.DeltaCost, -- DeltaCost
              d.DeltaQty, -- DeltaQty
              d.DeltaPrice, -- DeltaPrice
              CASE WHEN d.EffectQtyCost = 0 THEN z.EffectQtyCost END, -- EffectQtyCost
              CASE WHEN d.EffectPriceCost = 0 THEN z.EffectPriceCost END, -- EffectPriceCost
              d.EffectQtyCostPersent, -- EffectQtyCostPersent
              d.EffectPriceCostPersent, -- EffectPriceCostPersent
              CASE WHEN d.checker1 = 0 THEN z.checker1 END, -- checker1
              d.checker2  -- checker2
              )]::target_Cost_bom[], ', '))
              )]::target_Cost_bom[]
         FROM UNNEST(L2) d
         LEFT JOIN UNNEST(L3) z ON d.TreeNo = z.TreeNo
     );


/**********************************FACTOR ANALYSIS OF DATA************************************************************************************************/
 
  L3 = NULL;
  L4 = NULL;

  L2 = (SELECT ARRAY[(SELECT array_agg(array_to_string(ARRAY[( 
                       t0.Sel_Product_ID,
                       t0.LevelNo,
                       t0.Category,
                       t0.TreeNoParent,
                       t0.TreeNo,
                       t0.M_Product_ID,
                       t0.PP_Product_Bom_Parent_ID,
                       t0.BomQty1,
                       t0.BomQty2,
                       t0.PP_Product_Bom_ID,
                       t0.PP_Product_BomLine_ID,
                       t0.M_ProductBom_ID,
                       t0.M_Product_Category_ID,
                       t0.ComponentType1,
                       t0.ComponentType2,
                       t0.QtyBom1,
                       t0.IsQtyPercentage1,
                       t0.QtyBom2,
                       t0.IsQtyPercentage2,
                       t0.QtyRequiered1,
                       t0.BlUomQtyRequiered1,
                       t0.BlUom1_C_UOM_ID,
                       t0.QtyRequiered2,
                       t0.BlUomQtyRequiered2,
                       t0.BlUom2_C_UOM_ID,
                       t0.Price1,
                       t0.Price2,
                       t0.Cost1,
                       t0.Cost2,
                       t0.Description1,
                       t0.Description2,
                       t0.Cost2 - t0.Cost1, -- DeltaCost -- Cost change = cost date2 - cost date1
                       t0.QtyRequiered2 - t0.QtyRequiered1, -- DeltaQty -- Quantity change = QtyRequiered2 - QtyRequiered1
                       t0.Price2 - t0.Price1, -- DeltaPrice -- Price change = price2 - price1
                       COALESCE(t0.Price1, 0) * (COALESCE(t0.QtyRequiered2, 0) - COALESCE(t0.QtyRequiered1, 0)), -- EffectQtyCost -- Influence of quantity on change in cost = Price1 * Quantity change
                       t0.QtyRequiered2 * (t0.Price2 - t0.Price1), -- EffectPriceCost -- Impact of price on cost change = QtyRequiered2 * Price change
                       t0.EffectQtyCostPersent, -- 0 the calculation will be up the tree - Influence of quantity on change in cost, % = Influence of quantity on change in cost / Change in cost
                       t0.EffectPriceCostPersent, -- 0 the calculation will be up the tree - Impact of price on change in cost, % = Impact of price on change in cost / Change in cost
                       (t0.Price1 * (t0.QtyRequiered2 - t0.QtyRequiered1)) + (t0.QtyRequiered2 * (t0.Price2 - t0.Price1)), -- checker1
                       t0.checker2 -- 0 the calculation will be up the tree - Influence of quantity on change in cost, % + Influence of price on change in cost, %
                       )]::target_Cost_bom[], ', '))
                       )]::target_Cost_bom[]
                  FROM UNNEST(L2) t0
       );
           
/************************************************************/   
-- We will have to re-calculate costs from bottom to top and factor analysis
-- since all the values were needed to calculate linear data from factor analysis,
-- including semi-finished products and final products calculated in the previous similar cycle
-- and for some factor analysis columns you need to calculate sums up the tree

L3 = (SELECT ARRAY[(SELECT array_agg(array_to_string(ARRAY[(
             w1.LevelNo,
             w1.Category,
             w1.TreeNoParent,  
             w1.TreeNo,
             w1.Cost1,
             w1.Cost2,
             w1.EffectQtyCost,
             w1.EffectPriceCost,
             w1.checker1
             )]::target_Cost_bom_ReverseSum[], ', '))
             )]::target_Cost_bom_ReverseSum[]
        FROM UNNEST(L2) w1 
     );
             
LNo_FA = (SELECT max(s0.LevelNo) FROM UNNEST(L3) s0);

LOOP
-- We begin to calculate the cost in reverse order from raw materials to the final product
L4 = (SELECT ARRAY[(SELECT array_agg(array_to_string(ARRAY[(
             w1.LevelNo,
             w1.Category,
             w1.TreeNoParent,  
             w1.TreeNo,
             w1.sumCost1,
             w1.sumCost2,
             w1.sumEffectQtyCost,
             w1.sumEffectPriceCost,
             w1.sumChecker1
             )]::target_Cost_bom_ReverseSum[], ', '))
             )]::target_Cost_bom_ReverseSum[]
        FROM (SELECT w0.LevelNo,
                     0::NUMERIC AS Category,
                     w0.TreeNoParent,  
                     ''::CHARACTER VARYING AS TreeNo,
                     sum(w0.Cost1) AS sumCost1,
                     sum(w0.Cost2) AS sumCost2,
                     sum(w0.EffectQtyCost) AS sumEffectQtyCost,
                     sum(w0.EffectPriceCost) AS sumEffectPriceCost,
                     sum(w0.checker1) AS sumChecker1
                FROM UNNEST(L3) w0
               WHERE w0.LevelNo = LNo_FA
               GROUP BY w0.LevelNo,
                        w0.TreeNoParent) w1
     );
-- update prices for all levels    
L3 = (SELECT ARRAY[(SELECT array_agg(array_to_string(ARRAY[(
             m0.LevelNo,
             m0.Category,
             m0.TreeNoParent, 
             m0.TreeNo, 
             m0.CostNew1,
             m0.CostNew2,
             m0.EffectQtyCost,
             m0.EffectPriceCost,
             m0.checker1
             )]::target_Cost_bom_ReverseSum[], ', '))
             )]::target_Cost_bom_ReverseSum[]
        FROM (SELECT t0.LevelNo, 
                     t0.Category,
                     t0.TreeNoParent, 
                     t0.TreeNo,
                     t0.Cost1 AS CostNew1, -- do not recalculate the costs, we leave those already calculated earlier
                     t0.Cost2 AS CostNew2, -- do not recalculate the costs, we leave those already calculated earlier
                     -- recalculate only columns from factor analysis
                     -- at the same time strictly from the lower levels to the top, 
                     -- do not replace if 0, since the linear formula is valid only for the lower level, where the raw materials
                     COALESCE(t1.EffectQtyCost, t0.EffectQtyCost) AS EffectQtyCost,
                     COALESCE(t1.EffectPriceCost, t0.EffectPriceCost) AS EffectPriceCost,
                     COALESCE(t1.checker1, t0.checker1) AS checker1
                FROM UNNEST(L3) t0
                LEFT JOIN UNNEST(L4) t1 ON t1.TreeNoParent = t0.TreeNo 
                                       AND t0.LevelNo = LNo_FA-1) m0
     );

LNo_FA = LNo_FA - 1;

EXIT WHEN LNo_FA <= 0;

END LOOP;
    
   END IF; -- calculateCost = 'Y'
/************************************************************/

RETURN QUERY 
        SELECT d.Sel_Product_ID,
               d.LevelNo,
               d.Category,
               d.TreeNoParent,
               d.TreeNo,
               d.M_Product_ID,
               d.PP_Product_Bom_Parent_ID,
               d.BomQty1,
               d.BomQty2,
               d.PP_Product_Bom_ID,
               d.PP_Product_BomLine_ID,
               d.M_ProductBom_ID,
               d.M_Product_Category_ID,
               d.ComponentType1,
               d.ComponentType2,
               d.QtyBom1,
               d.IsQtyPercentage1,
               d.QtyBom2,
               d.IsQtyPercentage2,
               CASE 
                WHEN d.QtyRequiered1 <> 0
                 AND d.QtyRequiered1 < 0.00001
                THEN round(d.QtyRequiered1, 10)
                ELSE round(d.QtyRequiered1, 5)
                 END AS QtyRequiered1,
               CASE 
                WHEN d.BlUomQtyRequiered1 <> 0
                 AND d.BlUomQtyRequiered1 < 0.00001
                THEN round(d.BlUomQtyRequiered1, 10)
                ELSE round(d.BlUomQtyRequiered1, 5)
                 END AS BlUomQtyRequiered1,
               d.BlUom1_C_UOM_ID,
               CASE 
                WHEN d.QtyRequiered2 <> 0
                 AND d.QtyRequiered2 < 0.00001
                THEN round(d.QtyRequiered2, 10)
                ELSE round(d.QtyRequiered2, 5)
                 END AS QtyRequiered2,
               CASE 
                WHEN d.BlUomQtyRequiered2 <> 0
                 AND d.BlUomQtyRequiered2 < 0.00001
                THEN round(d.BlUomQtyRequiered2, 10)
                ELSE round(d.BlUomQtyRequiered2, 5)
                 END AS BlUomQtyRequiered2,
               d.BlUom2_C_UOM_ID,
               d.Price1,
               d.Price2,
               d.Cost1,
               d.Cost2,
               d.Description1,
               d.Description2,
               d.DeltaCost, -- DeltaCost -- Cost change = cost date2 - cost date1
               d.DeltaQty, -- DeltaQty -- Quantity change = QtyRequiered2 - QtyRequiered1
               d.DeltaPrice, -- DeltaPrice -- Price change = price2 - price1
               z.EffectQtyCost, -- EffectQtyCost -- Influence of quantity on change in cost = Price1 * Quantity change
               z.EffectPriceCost, -- EffectPriceCost -- Impact of price on cost change = QtyRequiered2 * Price change
               sign(z.checker1) * (CASE WHEN d.DeltaCost = 0 THEN 0 ELSE z.EffectQtyCost / d.DeltaCost END), -- EffectQtyCostPersent, - Influence of quantity on change in cost, % = Influence of quantity on change in cost / Change in cost
               sign(z.checker1) * (CASE WHEN d.DeltaCost = 0 THEN 0 ELSE z.EffectPriceCost / d.DeltaCost END), -- EffectPriceCostPersent, - Impact of price on change in cost, % = Impact of price on change in cost / Change in cost
               z.checker1,
               (sign(z.checker1) * (CASE WHEN d.DeltaCost = 0 THEN 0 ELSE z.EffectQtyCost / d.DeltaCost END))
               + (sign(z.checker1) * (CASE WHEN d.DeltaCost = 0 THEN 0 ELSE z.EffectPriceCost / d.DeltaCost END)) -- checker2 -- Influence of quantity on change in cost, % + Influence of price on change in cost, %
          FROM UNNEST(L2) d
          LEFT JOIN UNNEST(L3) z ON d.TreeNo = z.TreeNo;
     
L2 = NULL;
L3 = NULL;
L4 = NULL;

  END;

$function$
;

/*

-- EXAMPLE QUERY FOR REPORT

        SELECT Sel_Product_ID, 
               sel.name AS sel_name,
               r.LevelNo, 
               r.TreeNoParent, 
               r.TreeNo, 
               r.M_Product_ID, 
               p.name AS prodName,
               r.PP_Product_Bom_Parent_ID, 
               pp.name AS prodParentName,
               r.BomQty1, 
               r.BomQty2, 
               r.PP_Product_Bom_ID, 
               pb.name AS bomName,
               r.PP_Product_BomLine_ID, 
               blp.name AS bomlineName,
               r.M_ProductBom_ID, 
               r.M_Product_Category_ID, 
               r.ComponentType1, 
               r.ComponentType2, 
               r.QtyBom1, 
               r.IsQtyPercentage1,
               r.QtyBom2,
               r.IsQtyPercentage2,
               r.QtyRequiered1, 
               r.BlUomQtyRequiered1,
               r.BlUom1_C_UOM_ID,
               r.QtyRequiered2, 
               r.BlUomQtyRequiered2,
               r.BlUom2_C_UOM_ID,
               Price1, 
               Price2, 
               Cost1, 
               Cost2, 
               Description1, 
               Description2, 
               DeltaCost, 
               r.DeltaQty,
               DeltaPrice,
               EffectQtyCost,
               EffectPriceCost,
               EffectQtyCostPersent,
               EffectPriceCostPersent,
               checker1, 
               checker2
          FROM adempiere.target_Cost_bom(1000025, -- selProductId
                                         1000012, -- pProductBomId
                                         '2023-12-15'::timestamp WITHOUT time ZONE, -- pDate1
                                         '2024-03-01'::timestamp WITHOUT time ZONE, -- pDate2
                                         1::NUMERIC, -- pQtyRequiered
                                         'Y'::CHARACTER, -- calculateCost
                                         'Y'::CHARACTER, -- showComponentNextLevel
                                         'N'::CHARACTER, -- showVariants
                                         'N'::CHARACTER) r -- showOnlyFirstLevel
          LEFT JOIN m_product sel ON sel.M_Product_ID = r.Sel_Product_ID
          LEFT JOIN m_product p ON p.M_Product_ID = r.M_Product_ID
          LEFT JOIN pp_product_bom pp ON pp.PP_Product_Bom_ID = r.PP_Product_Bom_Parent_ID
          LEFT JOIN pp_product_bom pb ON pb.PP_Product_Bom_ID = r.PP_Product_Bom_ID
          LEFT JOIN pp_product_bomline pbl ON pbl.PP_Product_BomLine_ID = r.PP_Product_BomLine_ID
          LEFT JOIN m_product blp ON blp.M_Product_ID = pbl.M_Product_ID
         ORDER BY r.TreeNo;

*/

