select *, 
(
case when score between 0 and 5 
then 'Less Happy Country'
when score between 5 and 8
then 'Happy Country' end )
as country_status,
(
case when [GDP per capita] between 0 and 1
then 'Low GDP Country'
when [GDP per capita] between 1 and 2
then 'High GDP Country' end )

as GDP_status,
(
case when [Social support] between 0 and 1.2
then 'Low Social Support Country'
when [Social support] between 1.2 and 2
then 'High Social Support Country' end )

as Social_Support_status,
(
case when [Healthy life expectancy] between 0 and 0.6
then 'Low life expectancy Country'
when [Healthy life expectancy] between 0.6 and 1.5
then 'High life expectancy Country' end )

as Life_Expectancy_status,

(
case when [Freedom to make life choices] between 0 and 0.4
then 'Low Freedom to make life choices'
when [Freedom to make life choices] between 0.4 and 1
then 'High Freedom to make life choices' end )

as Freedom_to_make_life_choices_status,

(
case when [Generosity] between 0 and 0.2
then 'Less Generous Country'
when [Generosity] between 0.2 and 0.6
then 'High Generous Country' end )

as Generosity_status,

(
case when [Perceptions of corruption] between 0 and 0.1
then 'Less Corrupt Country'
when [Perceptions of corruption] between 0.1 and 0.5
then 'Highly Corrupt Country' end )

as Corruption_status



from [dbo].[Worksheet$];