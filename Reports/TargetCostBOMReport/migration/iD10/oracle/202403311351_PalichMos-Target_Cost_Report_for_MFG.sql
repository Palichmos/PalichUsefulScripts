-- Target_Cost_Report_for_Manufacturing from PalichMos
SELECT register_migration_script('202403311351_PalichMos-Target_Cost_Report_for_MFG.sql') FROM dual;

SET SQLBLANKLINES ON
SET DEFINE OFF

-- Mar 31, 2024, 1:51:20 PM SAMT
INSERT INTO AD_Process (AD_Process_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,Name,IsReport,Value,IsDirectPrint,AccessLevel,EntityType,Statistic_Count,Statistic_Seconds,IsBetaFunctionality,IsServerProcess,ShowHelp,JasperReport,CopyFromProcess,AD_Process_UU,AllowMultipleExecution) VALUES (200159,0,0,'Y',TO_TIMESTAMP('2024-03-31 13:51:18','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 13:51:18','YYYY-MM-DD HH24:MI:SS'),100,'BomQty Report','Y','10000000','N','3','D',0,0,'N','N','Y','attachment:BomQtyReport.jrxml','N','f14ceedd-72d9-4471-b38a-b78b72e9d793','P')
;

-- Mar 31, 2024, 1:54:56 PM SAMT
INSERT INTO AD_Process_Para (AD_Process_Para_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,Name,Description,Help,AD_Process_ID,SeqNo,AD_Reference_ID,IsRange,FieldLength,IsMandatory,ColumnName,IsCentrallyMaintained,EntityType,AD_Element_ID,AD_Process_Para_UU,IsEncrypted,IsAutocomplete,DateRangeOption,IsShowNegateButton) VALUES (200462,0,0,'Y',TO_TIMESTAMP('2024-03-31 13:54:56','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 13:54:56','YYYY-MM-DD HH24:MI:SS'),100,'Product','Product, Service, Item','Identifies an item which is either purchased or sold in this organization.',200159,10,30,'N',10,'Y','M_Product_ID','Y','D',454,'93c88c88-0ed1-4d54-8832-b61fcc25260e','N','N','D','N')
;

-- Mar 31, 2024, 1:55:40 PM SAMT
INSERT INTO AD_Process_Para (AD_Process_Para_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,Name,Description,AD_Process_ID,SeqNo,AD_Reference_ID,IsRange,AD_Val_Rule_ID,FieldLength,IsMandatory,ColumnName,IsCentrallyMaintained,EntityType,AD_Element_ID,AD_Process_Para_UU,IsEncrypted,IsAutocomplete,DateRangeOption,IsShowNegateButton) VALUES (200463,0,0,'Y',TO_TIMESTAMP('2024-03-31 13:55:39','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 13:55:39','YYYY-MM-DD HH24:MI:SS'),100,'BOM & Formula','BOM & Formula',200159,20,19,'N',200136,10,'N','PP_Product_BOM_ID','Y','D',53245,'4a008311-9abc-4e8c-b7ef-e903a7b695f5','N','N','D','N')
;

-- Mar 31, 2024, 1:56:46 PM SAMT
INSERT INTO AD_Process_Para (AD_Process_Para_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,Name,Description,AD_Process_ID,SeqNo,AD_Reference_ID,IsRange,FieldLength,IsMandatory,DefaultValue,ColumnName,IsCentrallyMaintained,EntityType,AD_Element_ID,AD_Process_Para_UU,IsEncrypted,IsAutocomplete,DateRangeOption,IsShowNegateButton) VALUES (200464,0,0,'Y',TO_TIMESTAMP('2024-03-31 13:56:45','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 13:56:45','YYYY-MM-DD HH24:MI:SS'),100,'Date Start','Date Start for this Order',200159,30,15,'N',10,'Y','@SQL= SELECT CURRENT_DATE','DateStart','Y','D',53280,'60e87c26-d339-46a1-991d-616ecbeac3a8','N','N','D','N')
;

-- Mar 31, 2024, 1:57:25 PM SAMT
INSERT INTO AD_Process_Para (AD_Process_Para_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,Name,AD_Process_ID,SeqNo,AD_Reference_ID,IsRange,FieldLength,IsMandatory,DefaultValue,ColumnName,IsCentrallyMaintained,EntityType,AD_Element_ID,AD_Process_Para_UU,IsEncrypted,IsAutocomplete,DateRangeOption,IsShowNegateButton) VALUES (200465,0,0,'Y',TO_TIMESTAMP('2024-03-31 13:57:25','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 13:57:25','YYYY-MM-DD HH24:MI:SS'),100,'Qty Required',200159,40,29,'N',22,'Y','1','QtyRequiered','Y','D',53288,'c2e592aa-8ddc-4df2-b810-19cc50dbc727','N','N','D','N')
;

-- Mar 31, 2024, 1:58:16 PM SAMT
INSERT INTO AD_Process_Para (AD_Process_Para_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,Name,AD_Process_ID,SeqNo,AD_Reference_ID,IsRange,FieldLength,IsMandatory,DefaultValue,ColumnName,IsCentrallyMaintained,EntityType,AD_Process_Para_UU,IsEncrypted,IsAutocomplete,DateRangeOption,IsShowNegateButton) VALUES (200466,0,0,'Y',TO_TIMESTAMP('2024-03-31 13:58:16','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 13:58:16','YYYY-MM-DD HH24:MI:SS'),100,'Show Component Next Level',200159,50,20,'N',1,'Y','Y','showComponentNextLevel','N','D','6d8a59bf-5372-40b9-b46b-59d2619e15d7','N','N','D','N')
;

-- Mar 31, 2024, 1:59:48 PM SAMT
INSERT INTO AD_Process_Para (AD_Process_Para_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,Name,AD_Process_ID,SeqNo,AD_Reference_ID,IsRange,FieldLength,IsMandatory,DefaultValue,ColumnName,IsCentrallyMaintained,EntityType,AD_Process_Para_UU,IsEncrypted,IsAutocomplete,DateRangeOption,IsShowNegateButton) VALUES (200467,0,0,'Y',TO_TIMESTAMP('2024-03-31 13:59:48','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 13:59:48','YYYY-MM-DD HH24:MI:SS'),100,'Show Variants',200159,60,20,'N',1,'Y','N','showVariants','N','D','835b9881-4ceb-455e-83e5-6cbb936fc067','N','N','D','N')
;

-- Mar 31, 2024, 2:00:23 PM SAMT
INSERT INTO AD_Process_Para (AD_Process_Para_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,Name,AD_Process_ID,SeqNo,AD_Reference_ID,IsRange,FieldLength,IsMandatory,DefaultValue,ColumnName,IsCentrallyMaintained,EntityType,AD_Process_Para_UU,IsEncrypted,IsAutocomplete,DateRangeOption,IsShowNegateButton) VALUES (200468,0,0,'Y',TO_TIMESTAMP('2024-03-31 14:00:23','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 14:00:23','YYYY-MM-DD HH24:MI:SS'),100,'Show Only First Level',200159,70,20,'N',1,'Y','N','showOnlyFirstLevel','N','D','d8c3b87e-1dda-4d60-bebf-090c2e32bdf3','N','N','D','N')
;

-- Mar 31, 2024, 2:01:25 PM SAMT
INSERT INTO AD_Process_Para (AD_Process_Para_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,Name,Description,Help,AD_Process_ID,SeqNo,AD_Reference_ID,IsRange,FieldLength,IsMandatory,DefaultValue,ColumnName,IsCentrallyMaintained,EntityType,AD_Element_ID,ReadOnlyLogic,AD_Process_Para_UU,IsEncrypted,IsAutocomplete,DateRangeOption,IsShowNegateButton) VALUES (200469,0,0,'Y',TO_TIMESTAMP('2024-03-31 14:01:24','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 14:01:24','YYYY-MM-DD HH24:MI:SS'),100,'User/Contact','User within the system - Internal or Business Partner Contact','The User identifies a unique user in the system. This could be an internal user or a business partner contact',200159,80,30,'N',10,'Y','@#AD_User_ID@','AD_User_ID','Y','D',138,'1=1','e874f5e8-85fd-40e8-96b4-66798a8b5d20','N','N','D','N')
;

-- Mar 31, 2024, 2:02:13 PM SAMT
UPDATE AD_Process SET Value='BomQty Report',Updated=TO_TIMESTAMP('2024-03-31 14:02:13','YYYY-MM-DD HH24:MI:SS'),UpdatedBy=100 WHERE AD_Process_ID=200159
;

-- Mar 31, 2024, 2:02:48 PM SAMT
INSERT INTO AD_Menu (AD_Menu_ID,Name,Action,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,IsSummary,AD_Process_ID,IsSOTrx,IsReadOnly,EntityType,IsCentrallyMaintained,AD_Menu_UU) VALUES (200235,'BomQty Report','R',0,0,'Y',TO_TIMESTAMP('2024-03-31 14:02:47','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 14:02:47','YYYY-MM-DD HH24:MI:SS'),100,'N',200159,'N','N','D','Y','de9a5bce-d95e-4ede-ae6e-21128c7bf32b')
;

-- Mar 31, 2024, 2:02:48 PM SAMT
INSERT INTO AD_TreeNodeMM (AD_Client_ID,AD_Org_ID, IsActive,Created,CreatedBy,Updated,UpdatedBy, AD_Tree_ID, Node_ID, Parent_ID, SeqNo, AD_TreeNodeMM_UU) SELECT t.AD_Client_ID, 0, 'Y', getDate(), 100, getDate(), 100,t.AD_Tree_ID, 200235, 0, 999, Generate_UUID() FROM AD_Tree t WHERE t.AD_Client_ID=0 AND t.IsActive='Y' AND t.IsAllNodes='Y' AND t.TreeType='MM' AND NOT EXISTS (SELECT * FROM AD_TreeNodeMM e WHERE e.AD_Tree_ID=t.AD_Tree_ID AND Node_ID=200235)
;

-- Mar 31, 2024, 2:04:33 PM SAMT
INSERT INTO AD_Process (AD_Process_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,Name,IsReport,Value,IsDirectPrint,AccessLevel,EntityType,Statistic_Count,Statistic_Seconds,IsBetaFunctionality,IsServerProcess,ShowHelp,JasperReport,CopyFromProcess,AD_Process_UU,AllowMultipleExecution) VALUES (200160,0,0,'Y',TO_TIMESTAMP('2024-03-31 14:04:33','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 14:04:33','YYYY-MM-DD HH24:MI:SS'),100,'BomQtyCost Report','Y','BomQtyCost Report','N','3','D',0,0,'N','N','Y','attachment:BomQtyCostReport.jrxml','N','cf12060a-7428-4da7-8b7b-f9c3854d6ba5','P')
;

-- Mar 31, 2024, 2:05:09 PM SAMT
INSERT INTO AD_Process_Para (AD_Process_Para_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,Name,Description,Help,AD_Process_ID,SeqNo,AD_Reference_ID,IsRange,FieldLength,IsMandatory,ColumnName,IsCentrallyMaintained,EntityType,AD_Element_ID,AD_Process_Para_UU,IsEncrypted,IsAutocomplete,DateRangeOption,IsShowNegateButton) VALUES (200470,0,0,'Y',TO_TIMESTAMP('2024-03-31 14:05:08','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 14:05:08','YYYY-MM-DD HH24:MI:SS'),100,'Product','Product, Service, Item','Identifies an item which is either purchased or sold in this organization.',200160,10,30,'N',10,'Y','M_Product_ID','Y','D',454,'b6283b53-cbb5-4dad-aa29-bef9adaa2bda','N','N','D','N')
;

-- Mar 31, 2024, 2:05:44 PM SAMT
INSERT INTO AD_Process_Para (AD_Process_Para_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,Name,Description,AD_Process_ID,SeqNo,AD_Reference_ID,IsRange,AD_Val_Rule_ID,FieldLength,IsMandatory,ColumnName,IsCentrallyMaintained,EntityType,AD_Element_ID,AD_Process_Para_UU,IsEncrypted,IsAutocomplete,DateRangeOption,IsShowNegateButton) VALUES (200471,0,0,'Y',TO_TIMESTAMP('2024-03-31 14:05:43','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 14:05:43','YYYY-MM-DD HH24:MI:SS'),100,'BOM & Formula','BOM & Formula',200160,20,19,'N',200136,10,'N','PP_Product_BOM_ID','Y','D',53245,'4b34e197-41d4-4ed3-b58d-a2c2132cde7d','N','N','D','N')
;

-- Mar 31, 2024, 2:06:46 PM SAMT
INSERT INTO AD_Process_Para (AD_Process_Para_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,Name,AD_Process_ID,SeqNo,AD_Reference_ID,IsRange,FieldLength,IsMandatory,DefaultValue,ColumnName,IsCentrallyMaintained,EntityType,AD_Process_Para_UU,IsEncrypted,IsAutocomplete,DateRangeOption,IsShowNegateButton) VALUES (200472,0,0,'Y',TO_TIMESTAMP('2024-03-31 14:06:46','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 14:06:46','YYYY-MM-DD HH24:MI:SS'),100,'Date Start',200160,30,15,'N',10,'Y','@SQL= SELECT CURRENT_DATE','DateStart','N','D','c678dbb4-5132-4bc0-a535-7c5852a59a20','N','N','D','N')
;

-- Mar 31, 2024, 2:07:13 PM SAMT
UPDATE AD_Process_Para SET AD_Element_ID=53280,Updated=TO_TIMESTAMP('2024-03-31 14:07:13','YYYY-MM-DD HH24:MI:SS'),UpdatedBy=100 WHERE AD_Process_Para_ID=200472
;

-- Mar 31, 2024, 2:07:53 PM SAMT
INSERT INTO AD_Process_Para (AD_Process_Para_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,Name,AD_Process_ID,SeqNo,AD_Reference_ID,IsRange,FieldLength,IsMandatory,DefaultValue,ColumnName,IsCentrallyMaintained,EntityType,AD_Element_ID,AD_Process_Para_UU,IsEncrypted,IsAutocomplete,DateRangeOption,IsShowNegateButton) VALUES (200473,0,0,'Y',TO_TIMESTAMP('2024-03-31 14:07:53','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 14:07:53','YYYY-MM-DD HH24:MI:SS'),100,'Qty Required',200160,40,29,'N',22,'Y','1','QtyRequiered','Y','D',53288,'d92156fa-4234-4b9e-8fe2-db75efdcb029','N','N','D','N')
;

-- Mar 31, 2024, 2:08:25 PM SAMT
INSERT INTO AD_Process_Para (AD_Process_Para_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,Name,Description,Help,AD_Process_ID,SeqNo,AD_Reference_ID,IsRange,FieldLength,IsMandatory,DefaultValue,ColumnName,IsCentrallyMaintained,EntityType,AD_Element_ID,ReadOnlyLogic,AD_Process_Para_UU,IsEncrypted,IsAutocomplete,DateRangeOption,IsShowNegateButton) VALUES (200474,0,0,'Y',TO_TIMESTAMP('2024-03-31 14:08:24','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 14:08:24','YYYY-MM-DD HH24:MI:SS'),100,'User/Contact','User within the system - Internal or Business Partner Contact','The User identifies a unique user in the system. This could be an internal user or a business partner contact',200160,50,30,'N',0,'Y','@#AD_User_ID@','AD_User_ID','Y','D',138,'1=1','75222f1c-7efb-4c03-90c7-bb814e0e10e8','N','N','D','N')
;

-- Mar 31, 2024, 2:08:32 PM SAMT
UPDATE AD_Process_Para SET FieldLength=10,Updated=TO_TIMESTAMP('2024-03-31 14:08:32','YYYY-MM-DD HH24:MI:SS'),UpdatedBy=100 WHERE AD_Process_Para_ID=200474
;

-- Mar 31, 2024, 2:09:11 PM SAMT
INSERT INTO AD_Menu (AD_Menu_ID,Name,Action,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,IsSummary,AD_Process_ID,IsSOTrx,IsReadOnly,EntityType,IsCentrallyMaintained,AD_Menu_UU) VALUES (200236,'BomQtyCost Report','R',0,0,'Y',TO_TIMESTAMP('2024-03-31 14:09:11','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 14:09:11','YYYY-MM-DD HH24:MI:SS'),100,'N',200160,'Y','N','D','Y','8f82793b-7fea-4533-bd49-c4291e521899')
;

-- Mar 31, 2024, 2:09:12 PM SAMT
INSERT INTO AD_TreeNodeMM (AD_Client_ID,AD_Org_ID, IsActive,Created,CreatedBy,Updated,UpdatedBy, AD_Tree_ID, Node_ID, Parent_ID, SeqNo, AD_TreeNodeMM_UU) SELECT t.AD_Client_ID, 0, 'Y', getDate(), 100, getDate(), 100,t.AD_Tree_ID, 200236, 0, 999, Generate_UUID() FROM AD_Tree t WHERE t.AD_Client_ID=0 AND t.IsActive='Y' AND t.IsAllNodes='Y' AND t.TreeType='MM' AND NOT EXISTS (SELECT * FROM AD_TreeNodeMM e WHERE e.AD_Tree_ID=t.AD_Tree_ID AND Node_ID=200236)
;

-- Mar 31, 2024, 2:10:29 PM SAMT
INSERT INTO AD_Process (AD_Process_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,Name,IsReport,Value,IsDirectPrint,AccessLevel,EntityType,Statistic_Count,Statistic_Seconds,IsBetaFunctionality,IsServerProcess,ShowHelp,JasperReport,CopyFromProcess,AD_Process_UU,AllowMultipleExecution) VALUES (200161,0,0,'Y',TO_TIMESTAMP('2024-03-31 14:10:29','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 14:10:29','YYYY-MM-DD HH24:MI:SS'),100,'Target Cost','Y','Target Cost','N','3','D',0,0,'N','N','Y','attachment:TargetCostBOMReport.jrxml','N','c9557b29-6013-4b9a-b64b-c27e49797890','P')
;

-- Mar 31, 2024, 2:11:03 PM SAMT
INSERT INTO AD_Process_Para (AD_Process_Para_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,Name,Description,Help,AD_Process_ID,SeqNo,AD_Reference_ID,IsRange,FieldLength,IsMandatory,ColumnName,IsCentrallyMaintained,EntityType,AD_Element_ID,AD_Process_Para_UU,IsEncrypted,IsAutocomplete,DateRangeOption,IsShowNegateButton) VALUES (200475,0,0,'Y',TO_TIMESTAMP('2024-03-31 14:11:02','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 14:11:02','YYYY-MM-DD HH24:MI:SS'),100,'Product','Product, Service, Item','Identifies an item which is either purchased or sold in this organization.',200161,10,30,'N',10,'Y','M_Product_ID','Y','D',454,'432de1f3-1f43-4511-92b2-630140320f9c','N','N','D','N')
;

-- Mar 31, 2024, 2:11:23 PM SAMT
INSERT INTO AD_Process_Para (AD_Process_Para_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,Name,Description,AD_Process_ID,SeqNo,AD_Reference_ID,IsRange,AD_Val_Rule_ID,FieldLength,IsMandatory,ColumnName,IsCentrallyMaintained,EntityType,AD_Element_ID,AD_Process_Para_UU,IsEncrypted,IsAutocomplete,DateRangeOption,IsShowNegateButton) VALUES (200476,0,0,'Y',TO_TIMESTAMP('2024-03-31 14:11:22','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 14:11:22','YYYY-MM-DD HH24:MI:SS'),100,'BOM & Formula','BOM & Formula',200161,20,19,'N',200136,10,'N','PP_Product_BOM_ID','Y','D',53245,'8c395310-5750-4eaa-a773-ef0149863400','N','N','D','N')
;

-- Mar 31, 2024, 2:12:38 PM SAMT
INSERT INTO AD_Process_Para (AD_Process_Para_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,Name,Description,AD_Process_ID,SeqNo,AD_Reference_ID,IsRange,FieldLength,IsMandatory,DefaultValue,ColumnName,DefaultValue2,IsCentrallyMaintained,EntityType,AD_Element_ID,AD_Process_Para_UU,IsEncrypted,IsAutocomplete,DateRangeOption,IsShowNegateButton) VALUES (200477,0,0,'Y',TO_TIMESTAMP('2024-03-31 14:12:37','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 14:12:37','YYYY-MM-DD HH24:MI:SS'),100,'Date Start','Date Start for this Order',200161,30,15,'Y',10,'Y','@SQL= SELECT CURRENT_DATE- INTERVAL ''7 days''','DateStart','@SQL= SELECT CURRENT_DATE','Y','D',53280,'e9ea1f66-b154-4014-bf6f-95ae9921cb64','N','N','D','N')
;

-- Mar 31, 2024, 2:13:04 PM SAMT
INSERT INTO AD_Process_Para (AD_Process_Para_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,Name,AD_Process_ID,SeqNo,AD_Reference_ID,IsRange,FieldLength,IsMandatory,DefaultValue,ColumnName,IsCentrallyMaintained,EntityType,AD_Element_ID,AD_Process_Para_UU,IsEncrypted,IsAutocomplete,DateRangeOption,IsShowNegateButton) VALUES (200478,0,0,'Y',TO_TIMESTAMP('2024-03-31 14:13:03','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 14:13:03','YYYY-MM-DD HH24:MI:SS'),100,'Qty Required',200161,40,29,'N',22,'Y','1','QtyRequiered','Y','D',53288,'2a25d46b-7c2f-4826-8881-67fde6a82f1b','N','N','D','N')
;

-- Mar 31, 2024, 2:13:15 PM SAMT
INSERT INTO AD_Process_Para (AD_Process_Para_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,Name,Description,Help,AD_Process_ID,SeqNo,AD_Reference_ID,IsRange,FieldLength,IsMandatory,DefaultValue,ColumnName,IsCentrallyMaintained,EntityType,AD_Element_ID,AD_Process_Para_UU,IsEncrypted,IsAutocomplete,DateRangeOption,IsShowNegateButton) VALUES (200479,0,0,'Y',TO_TIMESTAMP('2024-03-31 14:13:15','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 14:13:15','YYYY-MM-DD HH24:MI:SS'),100,'User/Contact','User within the system - Internal or Business Partner Contact','The User identifies a unique user in the system. This could be an internal user or a business partner contact',200161,50,30,'N',0,'N','-1','AD_User_ID','Y','D',138,'a63f2617-1ef9-43c3-b04b-8fbc1b22ee48','N','N','D','N')
;

-- Mar 31, 2024, 2:13:34 PM SAMT
UPDATE AD_Process_Para SET IsMandatory='Y', DefaultValue='@#AD_User_ID@', ReadOnlyLogic='1=1',Updated=TO_TIMESTAMP('2024-03-31 14:13:34','YYYY-MM-DD HH24:MI:SS'),UpdatedBy=100 WHERE AD_Process_Para_ID=200479
;

-- Mar 31, 2024, 2:14:00 PM SAMT
INSERT INTO AD_Menu (AD_Menu_ID,Name,Action,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,IsSummary,AD_Process_ID,IsSOTrx,IsReadOnly,EntityType,IsCentrallyMaintained,AD_Menu_UU) VALUES (200237,'Target Cost','R',0,0,'Y',TO_TIMESTAMP('2024-03-31 14:13:59','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 14:13:59','YYYY-MM-DD HH24:MI:SS'),100,'N',200161,'N','N','D','Y','dd124777-1da6-4c2c-b611-4885d40769b9')
;

-- Mar 31, 2024, 2:14:00 PM SAMT
INSERT INTO AD_TreeNodeMM (AD_Client_ID,AD_Org_ID, IsActive,Created,CreatedBy,Updated,UpdatedBy, AD_Tree_ID, Node_ID, Parent_ID, SeqNo, AD_TreeNodeMM_UU) SELECT t.AD_Client_ID, 0, 'Y', getDate(), 100, getDate(), 100,t.AD_Tree_ID, 200237, 0, 999, Generate_UUID() FROM AD_Tree t WHERE t.AD_Client_ID=0 AND t.IsActive='Y' AND t.IsAllNodes='Y' AND t.TreeType='MM' AND NOT EXISTS (SELECT * FROM AD_TreeNodeMM e WHERE e.AD_Tree_ID=t.AD_Tree_ID AND Node_ID=200237)
;

-- Mar 31, 2024, 2:14:10 PM SAMT
UPDATE AD_Menu SET IsSOTrx='N',Updated=TO_TIMESTAMP('2024-03-31 14:14:10','YYYY-MM-DD HH24:MI:SS'),UpdatedBy=100 WHERE AD_Menu_ID=200236
;

-- Mar 31, 2024, 2:15:11 PM SAMT
UPDATE AD_Process_Para SET Description=NULL,Updated=TO_TIMESTAMP('2024-03-31 14:15:11','YYYY-MM-DD HH24:MI:SS'),UpdatedBy=100 WHERE AD_Process_Para_ID=200464
;

-- Mar 31, 2024, 2:15:36 PM SAMT
UPDATE AD_Process_Para SET Description=NULL,Updated=TO_TIMESTAMP('2024-03-31 14:15:36','YYYY-MM-DD HH24:MI:SS'),UpdatedBy=100 WHERE AD_Process_Para_ID=200477
;

/* -- Need to attach manually
-- Mar 31, 2024, 2:16:22 PM SAMT
INSERT INTO AD_Attachment (AD_Attachment_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,AD_Table_ID,Record_ID,Title,TextMsg,AD_Attachment_UU,AD_StorageProvider_ID) VALUES (200043,0,0,'Y',TO_TIMESTAMP('2024-03-31 14:16:14','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 14:16:14','YYYY-MM-DD HH24:MI:SS'),100,284,200159,'xml',NULL,'79f28cb6-24a8-47b8-9f77-4917ef023660',toRecordId('AD_StorageProvider','43c8ef28-225e-47e5-9dc5-c66db9186b2c'))
;

-- Mar 31, 2024, 2:16:40 PM SAMT
INSERT INTO AD_Attachment (AD_Attachment_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,AD_Table_ID,Record_ID,Title,TextMsg,AD_Attachment_UU,AD_StorageProvider_ID) VALUES (200044,0,0,'Y',TO_TIMESTAMP('2024-03-31 14:16:29','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 14:16:29','YYYY-MM-DD HH24:MI:SS'),100,284,200160,'xml',NULL,'d596e365-9bc4-4248-a2b3-33e761e50826',toRecordId('AD_StorageProvider','43c8ef28-225e-47e5-9dc5-c66db9186b2c'))
;

-- Mar 31, 2024, 2:16:54 PM SAMT
INSERT INTO AD_Attachment (AD_Attachment_ID,AD_Client_ID,AD_Org_ID,IsActive,Created,CreatedBy,Updated,UpdatedBy,AD_Table_ID,Record_ID,Title,TextMsg,AD_Attachment_UU,AD_StorageProvider_ID) VALUES (200045,0,0,'Y',TO_TIMESTAMP('2024-03-31 14:16:44','YYYY-MM-DD HH24:MI:SS'),100,TO_TIMESTAMP('2024-03-31 14:16:44','YYYY-MM-DD HH24:MI:SS'),100,284,200161,'xml',NULL,'77d3f4f3-e188-42e1-8b94-4c2d701b9d78',toRecordId('AD_StorageProvider','43c8ef28-225e-47e5-9dc5-c66db9186b2c'))
;
*/

-- Mar 31, 2024, 3:24:25 PM SAMT
UPDATE AD_TreeNodeMM SET Parent_ID=53053, SeqNo=8,Updated=TO_TIMESTAMP('2024-03-31 15:24:25','YYYY-MM-DD HH24:MI:SS'),UpdatedBy=100 WHERE AD_Tree_ID=10 AND Node_ID=200235
;

-- Mar 31, 2024, 3:24:29 PM SAMT
UPDATE AD_TreeNodeMM SET Parent_ID=53053, SeqNo=9,Updated=TO_TIMESTAMP('2024-03-31 15:24:29','YYYY-MM-DD HH24:MI:SS'),UpdatedBy=100 WHERE AD_Tree_ID=10 AND Node_ID=200236
;

-- Mar 31, 2024, 3:24:33 PM SAMT
UPDATE AD_TreeNodeMM SET Parent_ID=53053, SeqNo=10,Updated=TO_TIMESTAMP('2024-03-31 15:24:33','YYYY-MM-DD HH24:MI:SS'),UpdatedBy=100 WHERE AD_Tree_ID=10 AND Node_ID=200237
;
