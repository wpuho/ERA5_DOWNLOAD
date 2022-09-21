#! /bin/sh

# =================

start_year=2016
end_year=2016
interval_year=01
start_month=07
end_month=07
interval_month=01
start_day=30
end_day=31
interval_day=01
start_hour=00
end_hour=18
interval_hour=01

header="specific"
# =================
for iyear in $(seq $start_year $interval_year $end_year)
do

for imon in $(seq $start_month $interval_month $end_month)
do
if [ $imon -lt 10 ]; then
imon="0"$imon
fi

for iday  in $(seq $start_day $interval_day $end_day)
do
if [ $iday -lt 10 ]; then
iday="0"$iday
fi

for ihr   in $(seq $start_hour $interval_hour $end_hour)
do
if [ $ihr -lt 10 ]; then
ihr="0"$ihr
fi

date=$iyear$imon$iday$ihr
file=$header"-"$date
echo $file
if [ -f $file ]; then

perl grb1to2.pl -fast $file

fi

done
done
done
done
