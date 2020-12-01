IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='facility')
    CREATE TABLE facility (
        Name varchar(64) not null
    )
GO