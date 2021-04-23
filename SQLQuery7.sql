select *,

(
case when [Country or region] LIKE '%Russia%' or [Country or region] LIKE '%Turkey%' 
then 'Europe_and_Asia'

when [Country or region] LIKE '%Canada%' or [Country or region] LIKE '%Costa Rica%' or [Country or region] LIKE '%United States%' or [Country or region] LIKE '%Mexico%' or
[Country or region] LIKE '%Guatemala%' or [Country or region] LIKE '%Panama%' or [Country or region] LIKE '%El Salvador%' or [Country or region] LIKE '%Nicaragua%' 
or [Country or region] LIKE '%Jamaica%' or [Country or region] LIKE '%Honduras%' or [Country or region] LIKE '%Haiti%' or [Country or region] LIKE '%Dominican Republic%'
then 'North America'

when [Country or region] LIKE '%New Zealand%' or [Country or region] LIKE '%Australia%' 
then 'Oceania'

end )


as Continent from[dbo].[Worksheet$];