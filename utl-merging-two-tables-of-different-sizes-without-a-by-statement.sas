Merging two tables of different sizes without a by statement

   Two Solutions

      1. Datastep merge
      2. Proc sql with monotonic key


see
https://tinyurl.com/y8qup5tw
https://github.com/rogerjdeangelis/utl-merging-two-tables-of-different-sizes-without-a-by-statement

Original Posted by
Mirisage Fernando
neilfrnnd@gmail.com


INPUT
=====

 WORK.HAVE_1 total obs=9

  ACCT_NUM      DATE       SIC

     11       30NOV2017    123
     11       30NOV2017    234
     11       30NOV2017      .
     11       30NOV2017      .
     11       30NOV2017      .
     11       30NOV2017      .
     11       30NOV2017    345
     11       30NOV2017      .
     11       30NOV2017      .

 WORK.HAVE_2 total obs=3

  ACCT_NUM      DATE

     11       30NOV2017
     11       24NOV2017
     11       24NOV2017


EXAMPLE OUTPUT
==============               RULES
                            Put Second table here
 WORK.WANT total obs=9      ---------------------

  ACCT_                        ACCT_
  NUM_1     DATE_1      SIC    NUM_2     DATE_2

    11     30NOV2017    123      11     30NOV2017
    11     30NOV2017    234      11     24NOV2017
    11     30NOV2017      .      11     24NOV2017
    11     30NOV2017      .       .
    11     30NOV2017      .       .
    11     30NOV2017      .       .
    11     30NOV2017    345       .
    11     30NOV2017      .       .
    11     30NOV2017      .       .


PROCESS
=======

1. Datastep merge

   data want;
     merge have_1(in=kep rename=(Acct_num = Acct_num_1 Date=Date_1))
           have_2(rename=(Acct_num = Acct_num_2 Date=Date_2));
     ;
     if kep;
   run;quit;

2. Proc sql with monotonic key

   proc sql;
     create
        table want as
     select
        l.Acct_num as Acct_num_1
       ,l.Date     as Date_1
       ,l.sic
       ,r.Acct_num as Acct_num_2
       ,r.Date     as Date_2

     from
       (select monotonic() as key, * from have_1) as l left join
       (select monotonic() as key, * from have_2) as r
     on
       l.key = r.key
   ;quit;

OUTPUT
======

 see above

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

data have_1;
input Acct_num date $10. SIC;
cards;
11 30NOV2017 123
11 30NOV2017 234
11 30NOV2017 .
11 30NOV2017 .
11 30NOV2017 .
11 30NOV2017 .
11 30NOV2017 345
11 30NOV2017 .
11 30NOV2017 .
;
run;

data have_2;
input Acct_num date $10.;
cards;
11 30NOV2017
11 24NOV2017
11 24NOV2017
;
run;

