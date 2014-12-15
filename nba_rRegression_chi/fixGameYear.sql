update  gameScore
set     game_year = 
            CASE 
                WHEN cast(substr(gameDate, 6, 2) as integer) <= 6
                    THEN 
                    cast(substr(gameDate, 1, 4) as integer) - 1
                ELSE
                    cast(substr(gameDate, 1, 4) as integer)
            END;
            