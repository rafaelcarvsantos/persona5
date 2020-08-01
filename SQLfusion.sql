USE [Persona5]
GO
/****** Object:  StoredProcedure [dbo].[fusao]    Script Date: 8/1/2020 3:21:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[fusao] (@source_1 varchar(250), @source_2 varchar(250))
AS

	declare @level_1 int = (select level from dim.persona where name = @source_1)
	declare @level_2 int = (select level from dim.persona where name = @source_2)

	declare @level_result decimal(10,2) = ceiling((@level_1 + @level_2)/2)+1

	declare @arcana_1 varchar(250) = (select arcana from dim.persona where name = @source_1)
	declare @arcana_2 varchar(250) = (select arcana from dim.persona where name = @source_2)


	declare @arcana_result varchar(250) = (select result from aux.fusion where source_1 = @arcana_1 and source_2 = @arcana_2)

	if @arcana_result is null 
	begin
		set @arcana_result = (select result from aux.fusion where source_2 = @arcana_1 and source_1 = @arcana_2)
	end

	if @arcana_result is null or @source_1 = @source_2
		begin
			print('Fusão impossível')
		end
	else
		begin
			select top 1 @source_1 +' + '+@source_2 as source, *
			from	dim.persona
			where	arcana = @arcana_result
			and		level >= @level_result
			order by ( level - @level_result ) 
		end



