

/****** Object:  Stored Procedure dbo.h3giGetCreditDashboardInfo    Script Date: 23/06/2005 13:35:16 ******/





/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.h3giGetCreditDashboardInfo
** Author			:	Gearóid Healy
** Date Created		:	17/05/2005
** Version			:	1.0.03
**					
**********************************************************************************************************************
**				
** Description		:	This procedure retrieves all info for a credit decisions and a credit agent
**					
**********************************************************************************************************************
**									
** Change Control	:	18/05/2005 - Gearóid Healy - now looks at b4nOrderHistory for creditAnalystIDs
**						11/06/2005 - Niall Carroll - Added casesCancelledTodayByAgent
**						
**********************************************************************************************************************
**									
** Parameters		:	@CreditAnalystID as int - the userID of the credit agent
**						
**********************************************************************************************************************/


CREATE              procedure dbo.h3giGetCreditDashboardInfo

		@CreditAnalystID int

AS

	declare @ExceedingSLAMins	as int
	declare @CurrentDate datetime
	
	select @ExceedingSLAMins = idValue from b4nsysdefaults with(nolock) where idName = 'exceedingSLA'
	set @CurrentDate = getDate()

	select
	
		(select count(b4no.orderref)
		from b4norderheader b4no with(nolock)
		where b4no.status = 300) as casesWaitingDecision,
		
		(select count(b4no.orderref)
		from b4norderheader b4no with(nolock)
		where b4no.status = 300
		and datediff(mi, b4no.orderdate, @CurrentDate) > @ExceedingSLAMins) as casesExceedingSLA,
		
		(select count(b4no.orderref)
		from b4norderheader b4no with(nolock)
		where b4no.status = 302) as casesWaitingMoreInfo,
	
		(select count(distinct(b4noh.orderref))
		from b4norderhistory b4noh with(nolock)
		where b4noh.orderstatus in (301, 302, 304, 305, 306)
		and datepart(yyyy, b4noh.statusdate) = datepart(yyyy, @CurrentDate)
		and datepart(dy, b4noh.statusdate) = datepart(dy, @CurrentDate)) as casesProcessedToday,
	
		(select count(distinct(b4noh.orderref))
		from b4norderhistory b4noh with(nolock)
		join h3giorderheader h3gio with(nolock) on b4noh.orderref = h3gio.orderref
		where (b4noh.orderstatus in (304, 305))
		and datepart(yyyy, b4noh.statusdate) = datepart(yyyy, @CurrentDate)
		and datepart(dy, b4noh.statusdate) = datepart(dy, @CurrentDate)) as casesDeclinedToday,
	
		(select count(distinct(b4noh.orderref))
		from b4norderhistory b4noh with(nolock)
		where b4noh.orderstatus = 306
		and datepart(yyyy, b4noh.statusdate) = datepart(yyyy, @CurrentDate)
		and datepart(dy, b4noh.statusdate) = datepart(dy, @CurrentDate)) as casesApprovedToday,

		(select count(distinct(b4noh.orderref))
		from b4norderhistory b4noh with(nolock)
		where b4noh.orderstatus = 301
		and datepart(yyyy, b4noh.statusdate) = datepart(yyyy, @CurrentDate)
		and datepart(dy, b4noh.statusdate) = datepart(dy, @CurrentDate)) as casesCancelledToday,

		(select count(distinct(b4noh.orderref))
		from b4norderhistory b4noh with(nolock)
		where b4noh.orderstatus = 302
		and datepart(yyyy, b4noh.statusdate) = datepart(yyyy, @CurrentDate)
		and datepart(dy, b4noh.statusdate) = datepart(dy, @CurrentDate)) as casesPendingToday,
	
		(select count(distinct(b4noh.orderref))
		from b4norderhistory b4noh with(nolock)
		where b4noh.orderstatus in (301, 302, 304, 305, 306)
		and b4noh.creditanalystid = @CreditAnalystID
		and datepart(yyyy, b4noh.statusdate) = datepart(yyyy, @CurrentDate)
		and datepart(dy, b4noh.statusdate) = datepart(dy, @CurrentDate)) as casesProcessedTodayByAgent,
	
		(select count(distinct(b4noh.orderref))
		from b4norderhistory b4noh with(nolock)
		join h3giorderheader h3gio with(nolock) on b4noh.orderref = h3gio.orderref
		join b4nclasscodes cc with(nolock) on h3gio.channelcode = cc.b4nclasscode and cc.b4nclasssysid = 'ChannelCode'
		where ((cc.b4nclassdesc = 'web' and b4noh.orderstatus = 305)
			or (cc.b4nclassdesc <> 'web' and b4noh.orderstatus = 304))
		and b4noh.creditanalystid = @CreditAnalystID
		and datepart(yyyy, b4noh.statusdate) = datepart(yyyy, @CurrentDate)
		and datepart(dy, b4noh.statusdate) = datepart(dy, @CurrentDate)) as casesDeclinedTodayByAgent,
	
		(select count(distinct(b4noh.orderref))
		from b4norderhistory b4noh with(nolock)
		where b4noh.orderstatus = 306
		and b4noh.creditanalystid = @CreditAnalystID
		and datepart(yyyy, b4noh.statusdate) = datepart(yyyy, @CurrentDate)
		and datepart(dy, b4noh.statusdate) = datepart(dy, @CurrentDate)) as casesApprovedTodayByAgent,

		(select count(distinct(b4noh.orderref))
		from b4norderhistory b4noh with(nolock)
		where b4noh.orderstatus = 301
		and b4noh.creditanalystid = @CreditAnalystID
		and datepart(yyyy, b4noh.statusdate) = datepart(yyyy, @CurrentDate)
		and datepart(dy, b4noh.statusdate) = datepart(dy, @CurrentDate)) as casesCancelledTodayByAgent,

		(select count(distinct(b4noh.orderref))
		from b4norderhistory b4noh with(nolock)
		where b4noh.orderstatus = 302
		and b4noh.creditanalystid = @CreditAnalystID
		and datepart(yyyy, b4noh.statusdate) = datepart(yyyy, @CurrentDate)
		and datepart(dy, b4noh.statusdate) = datepart(dy, @CurrentDate)) as casesPendingTodayByAgent









GRANT EXECUTE ON h3giGetCreditDashboardInfo TO b4nuser
GO
GRANT EXECUTE ON h3giGetCreditDashboardInfo TO helpdesk
GO
GRANT EXECUTE ON h3giGetCreditDashboardInfo TO ofsuser
GO
GRANT EXECUTE ON h3giGetCreditDashboardInfo TO reportuser
GO
GRANT EXECUTE ON h3giGetCreditDashboardInfo TO b4nexcel
GO
GRANT EXECUTE ON h3giGetCreditDashboardInfo TO b4nloader
GO
