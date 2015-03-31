


/****** Object:  Stored Procedure dbo.h3giGetTelesalesDashboardInfo    Script Date: 23/06/2005 13:35:22 ******/



/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.h3giGetTelesalesDashboardInfo
** Author			:	Gearóid Healy
** Date Created		:	17/05/2005
** Version			:	1.0.01
**					
**********************************************************************************************************************
**				
** Description		:	This procedure retrieves all info for a telesales agent
**					
**********************************************************************************************************************
**									
** Change Control	:	19/05/2005 - Gearóid Healy - Fixed bug with total orders today for an agent
**						
**********************************************************************************************************************
**									
** Parameters		:	@TelesalesID as int - the userID of the telesales agent
**						
**********************************************************************************************************************/


CREATE       procedure dbo.h3giGetTelesalesDashboardInfo

		@TelesalesID int

AS
	
declare @totalSalesLastWeek int,
@totalSalesToNowLastWeek int,
@totalSalesToDateThisWeek int,
@totalSalesToday int

select @totalSalesLastWeek = count(h3gioh2.orderref)
		from h3giorderheader h3gioh2 with(nolock)
		join b4norderheader b4noh2 with(nolock) on h3gioh2.orderref = b4noh2.orderref
		where datepart(yyyy, b4noh2.orderdate) = datepart(yyyy, getdate())
		and datepart(wk, b4noh2.orderdate) = datepart(wk, dateadd(wk, -1, getdate()))
		and h3gioh2.telesalesid = @telesalesid
		group by h3gioh2.telesalesid

select @totalSalesToNowLastWeek =  count(h3gioh2.orderref)
		from h3giorderheader h3gioh2 with(nolock)
		join b4norderheader b4noh2 with(nolock) on h3gioh2.orderref = b4noh2.orderref
		where datepart(yyyy, b4noh2.orderdate) = datepart(yyyy, getdate())
		and datepart(wk, b4noh2.orderdate) = datepart(wk, dateadd(wk, -1, getdate()))
		and datepart(dw, b4noh2.orderdate) <= datepart(dw, getdate())
		and h3gioh2.telesalesid = @telesalesid
		group by h3gioh2.telesalesid

select @totalSalesToDateThisWeek = count(h3gioh2.orderref)
		from h3giorderheader h3gioh2 with(nolock)
		join b4norderheader b4noh2 with(nolock) on h3gioh2.orderref = b4noh2.orderref
		where datepart(yyyy, b4noh2.orderdate) = datepart(yyyy, getdate())
		and datepart(wk, b4noh2.orderdate) = datepart(wk, getdate())
		and h3gioh2.telesalesid = @telesalesid
		group by h3gioh2.telesalesid

select @totalSalesToday = count(h3gioh2.orderref)
		from h3giorderheader h3gioh2 with(nolock)
		join b4norderheader b4noh2 with(nolock) on h3gioh2.orderref = b4noh2.orderref
		where datepart(yyyy, b4noh2.orderdate) = datepart(yyyy, getdate())
		and datepart(dy, b4noh2.orderdate) = datepart(dy, getdate())
		and h3gioh2.telesalesid = @telesalesid
		group by h3gioh2.telesalesid

	select au.nameofuser, max(b4noh.orderdate) as lastOrderDate, 
		isnull(@totalSalesLastWeek,0) as totalSalesLastWeek,
		isnull(@totalSalesToNowLastWeek,0) as totalSalesToNowLastWeek,
		isnull(@totalSalesToDateThisWeek,0) as totalSalesToDateThisWeek,
		isnull(@totalSalesToday,0) as totalSalesToday
	from h3giorderheader h3gioh with(nolock)
	join b4norderheader b4noh with(nolock) on h3gioh.orderref = b4noh.orderref
	join smapplicationusers au with(nolock) on h3gioh.telesalesid = au.userid
	where h3gioh.telesalesid = @telesalesid
	group by h3gioh.telesalesid, au.nameofuser






GRANT EXECUTE ON h3giGetTelesalesDashboardInfo TO b4nuser
GO
GRANT EXECUTE ON h3giGetTelesalesDashboardInfo TO helpdesk
GO
GRANT EXECUTE ON h3giGetTelesalesDashboardInfo TO ofsuser
GO
GRANT EXECUTE ON h3giGetTelesalesDashboardInfo TO reportuser
GO
GRANT EXECUTE ON h3giGetTelesalesDashboardInfo TO b4nexcel
GO
GRANT EXECUTE ON h3giGetTelesalesDashboardInfo TO b4nloader
GO
