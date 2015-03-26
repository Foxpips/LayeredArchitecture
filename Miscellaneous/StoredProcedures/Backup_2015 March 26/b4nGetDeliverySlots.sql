

/****** Object:  Stored Procedure dbo.b4nGetDeliverySlots    Script Date: 23/06/2005 13:31:40 ******/



CREATE procedure dbo.b4nGetDeliverySlots
as
begin
SELECT  DeliverySlotID,StartTime, EndTime, Cost
FROM b4ndeliveryslot 
where (Cutofftime >= GETDATE()) AND (Capacity > ordercount)
and starttime <= dateadd(day,90,getdate())
ORDER BY StartTime
end





GRANT EXECUTE ON b4nGetDeliverySlots TO b4nuser
GO
GRANT EXECUTE ON b4nGetDeliverySlots TO helpdesk
GO
GRANT EXECUTE ON b4nGetDeliverySlots TO ofsuser
GO
GRANT EXECUTE ON b4nGetDeliverySlots TO reportuser
GO
GRANT EXECUTE ON b4nGetDeliverySlots TO b4nexcel
GO
GRANT EXECUTE ON b4nGetDeliverySlots TO b4nloader
GO
