#!/bin/bash -l

# --------- Update History ---------

# 2021/07/08
#     ADD (1 HOUR_INTERVAL, (2 Boolean variables, (3 OutName, (4 cvtgrb2 options
# to make the program  more flexible.
#
# ---------------------------------

# ------- Basic Information -------

#     This script was contributed by the following link:
# https://dreambooker.site/2019/10/03/Initializing-the-WRF-model-with-ERA5-pressure-level/
# and modified at 2021/01/27
#
#     - The original program integrate all data into one grib file,
# but in the modification I seprate them to different files
# which divided by hours.
#
# Requirements --
# 1. GetERA5-sl.py
# 2. GetERA5-pl.py
# 3. .cpsapirc 
#

# ==================================

########## User define section ##########

DATADIR=/home/wpuho/DATA/EC_data/ERA5/data

#DATE_START=(2017101318 2016102006 2016073118 2015070512 2013081206 2010101900 2009061812 2008092200 2008041700 2006080100 2006051512 2005092200 2003090106)
#DATE_END=(2017101606 2016102112 2016080206 2015070918 2013081500 2010102318 2009062118 2008092412 2008041918 2006080406 2006051800 2005092618 2003090300)
#DATE_START=(2018091506 2016101606 2012081512 2012072018 2011092712 2009071706 2003082300 2003072212)
#DATE_END=(2018091700 2016101900 2012081712 2012072406 2011093000 2009071900 2003082512 2003072412)
#DATE_START=(2014071612 2013092018 2013063006 2010071900 2009091218 2005081206)
#DATE_END=(2014071912 2013092300 2013070206 2010072218 2009091506 2005081312)
# Sarika Khanun Haima Nida
#DATE_START=(2016101600 2017101306 2016102000 2016073112)
#DATE_END=(2016101600 2017101312 2016102000 2016073112)

DATE_START=(2005081200)
DATE_END=(2005081200)
HOUR_INTERVAL=6  # Never set HOUR_INTERVAL=0, even if DATE_START and DATE_END are the same
		 # and in that situation set HOUR_INTERVAL=1
#Nort=45
#West=75
#Sout=-45
#East=180
Nort=90
West=-180
Sout=-90
East=180
Single_level=true
sl_cvtgrb2=false
Press_level=true
pl_cvtgrb2=false
Specific=true
sp_cvtgrb2=true

OutName_1=sl  # single level
OutName_2=pl  # pressure level
OutName_3=sst # specific variable


#########################################
len=${#DATE_START[@]}
for ((i=0; i<$len; i++))
do

ds=${DATE_START[$i]}
de=${DATE_END[$i]}

iyear1=`echo $ds | cut -c1-4`
imon1=`echo $ds | cut -c5-6`
iday1=`echo $ds | cut -c7-8`
ihr1=`echo $ds | cut -c9-10`
date1=`date -d "$iyear1-$imon1-$iday1 $ihr1:00:00" +%s`
date1=`expr $date1 +  3600 \* 0`

iyear2=`echo $de | cut -c1-4`
imon2=`echo $de | cut -c5-6`
iday2=`echo $de | cut -c7-8`
ihr2=`echo $de | cut -c9-10`
date2=`date -d "$iyear2-$imon2-$iday2 $ihr2:00:00" +%s`

while [ $date1 -le $date2 ]
do

  DATE=`date "+%Y%m%d%H" --date=@$date1`
  iyear=`echo $DATE | cut -c1-4`
  imon=`echo $DATE | cut -c5-6`
  iday=`echo $DATE | cut -c7-8`
  ihr=`echo $DATE | cut -c9-10`
  
  echo 'Downloading... '$iyear'-'$imon'-'$iday'_'$ihr':00:00'

# =======  For single level

		if [ "$Single_level" == true ]; then

			sed -e "1,28s/iyear/${iyear}/g;1,28s/imon/${imon}/g;1,28s/iday/${iday}/g;1,28s/itime/${ihr}/g;s/Nort/${Nort}/g;s/West/${West}/g;s/Sout/${Sout}/g;s/East/${East}/g;s/Output_Name/${OutName_1}/g;" GetERA5-sl.py > GetERA5-${DATE}-sl.py

			python3 "GetERA5-"$DATE"-sl.py"

			rm "GetERA5-"$DATE"-sl.py"
#			mv "GetERA5-"$DATE"-sl.grib" $DATADIR

			if [ "$sl_cvtgrb2" == true ]; then

				mv $OutName_1"-"$DATE ./util_grb1to2/
                cd ./util_grb1to2/
				perl grb1to2.pl -fast $OutName_1"-"$DATE
                cd ..
				mv ./util_grb1to2/$OutName_1-$DATE* ./data
			
			else

				mv ./$OutName_1-$DATE* ./data

			fi

		fi

# ======= For pressure level

		if [ "$Press_level" == true ]; then
		
			sed -e "1,40s/iyear/${iyear}/g;1,40s/imon/${imon}/g;1,40s/iday/${iday}/g;1,40s/itime/${ihr}/g;s/Nort/${Nort}/g;s/West/${West}/g;s/Sout/${Sout}/g;s/East/${East}/g;s/Output_Name/${OutName_2}/g;" GetERA5-pl.py > GetERA5-${DATE}-pl.py

			python3 "GetERA5-"$DATE"-pl.py"

			rm "GetERA5-"$DATE"-pl.py"
#			mv "GetERA5-"$DATE"-pl.grib" $DATADIR

			if [ "$pl_cvtgrb2" == true ]; then

				mv $OutName_2"-"$DATE ./util_grb1to2/
                cd util_grb1to2/
				perl grb1to2.pl -fast $OutName_2"-"$DATE
                cd ..
				mv ./util_grb1to2/$OutName_2-$DATE* ./data
			
			else

				mv ./$OutName_2-$DATE* ./data

			fi

		fi

# =======  For specific variable

		if [ "$Specific" == true ]; then

			sed -e "1,28s/iyear/${iyear}/g;1,28s/imon/${imon}/g;1,28s/iday/${iday}/g;1,28s/itime/${ihr}/g;s/Nort/${Nort}/g;s/West/${West}/g;s/Sout/${Sout}/g;s/East/${East}/g;s/Output_Name/${OutName_3}/g;" GetERA5-specific.py > GetERA5-${DATE}-specific.py

			python3 "GetERA5-"$DATE"-specific.py"

			rm "GetERA5-"$DATE"-specific.py"
#			mv "GetERA5-"$DATE"-specific.grib" $DATADIR

			if [ "$sp_cvtgrb2" == true ]; then

				mv $OutName_3"-"$DATE ./util_grb1to2/
                cd ./util_grb1to2/
				perl grb1to2.pl -fast $OutName_3"-"$DATE
                cd ..
				mv ./util_grb1to2/$OutName_3-$DATE* ./data
			
			else

				mv ./$OutName_3-$DATE* ./data

			fi

		fi

# =======

  date1=`expr $date1 +  3600 \* $HOUR_INTERVAL`

done

if [ -d "/home/wpuho/Models/DATA/ERA5/"$ds"-"$de ]; then
    mv ./data/* "/home/wpuho/Models/DATA/ERA5/"$ds"-"$de
else
    path=`pwd`
    cd "/home/wpuho/Models/DATA/ERA5/"
    mkdir $ds"-"$de
    cd $path
    mv ./data/* "/home/wpuho/Models/DATA/ERA5/"$ds"-"$de
fi

done

exit 0

#mv $OutName_1'*' $DATADIR
#mv $OutName_2'*' $DATADIR
#mv $OutName_3'*' $DATADIR
