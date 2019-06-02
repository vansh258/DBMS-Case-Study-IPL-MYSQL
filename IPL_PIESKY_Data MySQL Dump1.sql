use ipl1;
select * from ipl_user;
select * from ipl_bidder_points;
select * from ipl_stadium;
select * from ipl_team;
select * from ipl_player;
 select * from ipl_team_players;
 select * from ipl_tournament;
select * from ipl_match;
select * from ipl_bidding_details;
select * from ipl_bidder_points;
#1.	Show the percentage of wins of each bidder in the order of highest to lowest percentage.
select bd.*, bp.no_of_bids,bp.total_points,(sum(bd.bid_status='Won')/bp.no_of_bids)*100 as
 'percentage_of_wins'
from ipl_bidding_details bd inner join ipl_bidder_points bp
on bd.bidder_id=bp.bidder_id
group by bd.bidder_id
order by percentage_of_wins desc;
#2.	Which teams have got the highest and the lowest no. of bids?
select * from ipl_team;
select * from ipl_bidding_details;
select t.*,count(bd.bid_team) as 'number_of_bids'
from ipl_bidding_details bd inner join ipl_team t
on 	t.team_id=bd.bid_team
group by t.team_id;
#hence srh has highest number of bid and chennai,mumbai,kolkata has lowest number of bids

#4.	What is the total no. of bids placed on the team that has won highest no. of matches?
create view abc as
select *,
case
when  match_winner =1 then team_id1
when match_winner=2 then team_id2
end as 'team_who_won'
from ipl_match;
select *, count(team_who_won) from abc
group by team_who_won;
#it is clear from the above table RR(team id 6) won the highest number of matches
select *, count(bid_team) from ipl_bidding_details
group by bid_team
having bid_team=6;
#hence total number of bids placed on team 6(rajasthan royals) was 27
#3.	In a given stadium, what is the percentage of wins by a team which had won the toss?
create view jai as
select s.stadium_name,s.stadium_id,count(m.toss_winner) as ab
from ipl_stadium s inner join ipl_match_schedule ms
on s.stadium_id=ms.stadium_id
inner join ipl_match m
on m.match_id=ms.match_id
where m.toss_winner=m.match_winner
group by stadium_name;
select jai.stadium_name,jai.stadium_id,(ab/count(ms.stadium_id))*100 as '% win in a stadium when a team won the toss'
from jai inner join ipl_match_schedule ms
on jai.stadium_id=ms.stadium_id
group by jai.stadium_name;
#5.	From the current team standings, if a bidder places a bid on which of the teams, 
#there is a possibility of (s)he winning the highest no. of points – in simple words,
 #identify the team which has the highest jump in its total points (in terms of percentage)
 #from the previous year to current year.
 select * from ipl_team_standings;
create view points_in_2017 as
select tournmt_id,total_points,team_id 
from ipl_team_standings
where tournmt_id=2017;
create view points_in_2018 as
select tournmt_id,total_points,team_id 
from ipl_team_standings
where tournmt_id=2018;
select a.team_id,((b.total_points-a.total_points)/a.total_points)*100
from points_in_2017 a inner join points_in_2018 b
on a.team_id=b.team_id;
#hence team_id= 6 made the highest jump in its total points in terms
# of percentage from previous year to this year