--- Deep Dive into CTE recursive querries

CREATE TABLE BillOfMaterials (
    ID INT PRIMARY KEY,
    ParentID INT NULL,
    ComponentName NVARCHAR(100),
    Quantity INT,
    Description NVARCHAR(255)
);

---- Generate some records

INSERT INTO BillOfMaterials (ID, ParentID, ComponentName, Quantity, Description) VALUES
(1, NULL, 'Laptop', 1, 'Final Product'),
(2, 1, 'Motherboard', 1, 'Main circuit board'),
(3, 1, 'Battery', 1, 'Lithium-ion battery'),
(4, 1, 'Display Assembly', 1, 'LCD screen and frame'),
(5, 2, 'CPU', 1, 'Central Processing Unit'),
(6, 2, 'RAM', 2, '8GB RAM modules'),
(7, 2, 'Chipset', 1, 'Motherboard controller'),
(8, 5, 'Thermal Paste', 1, 'For heat dissipation'),
(9, 5, 'Heat Sink', 1, 'Cools the CPU'),
(10, 4, 'LCD Panel', 1, '15.6 inch display'),
(11, 4, 'Backlight', 1, 'LED lighting system'),
(12, 3, 'Battery Cells', 4, 'Individual Li-ion cells'),
(13, 12, 'Electrolyte Gel', 1, 'For ion transfer'),
(14, 6, 'Memory Chip', 8, 'DRAM chips on module'),
(15, 14, 'Silicon Wafer', 1, 'Base for chip fabrication'),
(16, 15, 'Doping Material', 1, 'Used in semiconductor layer'),
(17, 7, 'Southbridge', 1, 'Controls peripherals'),
(18, 7, 'Northbridge', 1, 'Connects CPU and memory'),
(19, 17, 'Clock Generator', 1, 'Timing signal provider'),
(20, 19, 'Crystal Oscillator', 1, 'Provides base frequency');

---------------------------------------------------------------------
---- 1-Basic Tree Structure
;with cte as
(
  ---- anchor member 
  select ID, ComponentName, ParentID, Quantity, 0 as NodeLevel 
  from BillOfMaterials
  where ParentID is null

  union all
  ---- recursive member
  select b.ID, b.ComponentName, b.ParentID, b.Quantity, cte.NodeLevel +1 
  from BillOfMaterials as b
  inner join cte on b.ParentID=cte.ID
   
)

select * from cte order by NodeLevel asc

---- 2-Query showing the parent component that each component depends on
;with cte as
(
  ---- anchor member 
  select ID, ComponentName, ParentID, Quantity, 0 as NodeLevel 
  from BillOfMaterials
  where ParentID is null

  union all
  ---- recursive member
  select b.ID, b.ComponentName, b.ParentID, b.Quantity, cte.NodeLevel +1 
  from BillOfMaterials as b
  inner join cte on b.ParentID=cte.ID
   
)

SELECT 
    cte.ID,
    cte.ComponentName,
    cte.ParentID,
    b.ComponentName AS ParentComponentName,
    cte.NodeLevel
FROM cte
LEFT JOIN BillOfMaterials AS b ON cte.ParentID = b.ID
ORDER BY cte.NodeLevel ASC, cte.ID;

---- 3-Leaf Nodes: the query that lists the components under which there are no other components (no children)
---- First solution
;with cte as
(
  ---- anchor member 
  select ID, ComponentName, ParentID, Quantity, 0 as NodeLevel 
  from BillOfMaterials
  where ParentID is null

  union all
  ---- recursive member
  select b.ID, b.ComponentName, b.ParentID, b.Quantity, cte.NodeLevel +1 
  from BillOfMaterials as b
  inner join cte on b.ParentID=cte.ID
  
)

select ID,ComponentName from cte 
where ID in (select ID from cte except select ParentID from cte) 
order by ID asc

---- Second solution
;with cte as
(
  select ID, 
         ComponentName,
		 ParentID
  from BillOfMaterials
)

select 
       p.ID,
       p.ComponentName
from cte as p
left join cte as c on p.ID=c.ParentID
where c.ID is null
ORDER BY p.ID

---- 4-How Many Subcomponents Are Under Each Component?
;with cte as
(
  ---- anchor member 
  select ParentID, ID as ChildID 
  from BillOfMaterials
  where ParentID is not null

  union all
  ---- recursive member
  select cte.ParentID, b.ID
  from BillOfMaterials as b
  inner join cte on b.ParentID=cte.ChildID
   
)

select cte.ParentID as ID, b.ComponentName,count(cte.ParentID) as TotalSubComponents 
from cte 
inner join BillOfMaterials as b on cte.ParentID= b.ID
group by cte.ParentID,b.ComponentName
order by ID asc

