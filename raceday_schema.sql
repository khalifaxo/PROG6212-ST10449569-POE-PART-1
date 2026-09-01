IF DB_ID('RaceDayDB') IS NULL
BEGIN
    CREATE DATABASE RaceDayDB;
END
GO

USE RaceDayDB;
GO

IF OBJECT_ID('dbo.Results', 'U') IS NOT NULL DROP TABLE dbo.Results;
IF OBJECT_ID('dbo.Enrolments', 'U') IS NOT NULL DROP TABLE dbo.Enrolments;
IF OBJECT_ID('dbo.EventRoutes', 'U') IS NOT NULL DROP TABLE dbo.EventRoutes;
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID('dbo.Events', 'U') IS NOT NULL DROP TABLE dbo.Events;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
GO

CREATE TABLE dbo.Users (
    UserId          INT IDENTITY(1,1)      PRIMARY KEY,
    FullName        NVARCHAR(100)          NOT NULL,
    Email           NVARCHAR(150)          NOT NULL UNIQUE,
    PasswordHash    NVARCHAR(255)          NOT NULL,
    Role            NVARCHAR(20)           NOT NULL CHECK (Role IN ('Organiser','Participant')),
    CreatedAt       DATETIME               NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE dbo.Events (
    EventId         INT IDENTITY(1,1)      PRIMARY KEY,
    OrganiserId     INT                    NOT NULL,
    EventName       NVARCHAR(150)          NOT NULL,
    Description     NVARCHAR(MAX)          NULL,
    EventDate       DATE                   NOT NULL,
    Location        NVARCHAR(150)          NOT NULL,
    Province        NVARCHAR(50)           NOT NULL,
    EventType       NVARCHAR(20)           NOT NULL CHECK (EventType IN ('Running','Walking','Cycling')),
    CreatedAt       DATETIME               NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Events_Organiser FOREIGN KEY (OrganiserId) REFERENCES dbo.Users(UserId)
);
GO

CREATE TABLE dbo.Categories (
    CategoryId      INT IDENTITY(1,1)      PRIMARY KEY,
    EventId         INT                    NOT NULL,
    CategoryName    NVARCHAR(100)          NOT NULL,
    DistanceKm      DECIMAL(6,2)           NOT NULL,
    MaxParticipants INT                    NOT NULL DEFAULT 100,
    EntryFee        DECIMAL(8,2)           NOT NULL DEFAULT 0,
    CONSTRAINT FK_Categories_Event FOREIGN KEY (EventId) REFERENCES dbo.Events(EventId) ON DELETE CASCADE
);
GO

CREATE TABLE dbo.EventRoutes (
    RouteId         INT IDENTITY(1,1)      PRIMARY KEY,
    EventId         INT                    NOT NULL,
    RouteName       NVARCHAR(100)          NOT NULL,
    DistanceKm      DECIMAL(6,2)           NOT NULL,
    ElevationGainM  INT                    NULL,
    StartPoint      NVARCHAR(150)          NOT NULL,
    EndPoint        NVARCHAR(150)          NOT NULL,
    GpxFileUrl      NVARCHAR(255)          NULL,
    CONSTRAINT FK_Routes_Event FOREIGN KEY (EventId) REFERENCES dbo.Events(EventId) ON DELETE CASCADE
);
GO

CREATE TABLE dbo.Enrolments (
    EnrolmentId     INT IDENTITY(1,1)      PRIMARY KEY,
    ParticipantId   INT                    NOT NULL,
    CategoryId      INT                    NOT NULL,
    EnrolmentDate   DATETIME               NOT NULL DEFAULT GETDATE(),
    BibNumber       NVARCHAR(20)           NULL,
    Status          NVARCHAR(20)           NOT NULL DEFAULT 'Confirmed' CHECK (Status IN ('Confirmed','Cancelled')),
    CONSTRAINT FK_Enrolments_Participant FOREIGN KEY (ParticipantId) REFERENCES dbo.Users(UserId),
    CONSTRAINT FK_Enrolments_Category FOREIGN KEY (CategoryId) REFERENCES dbo.Categories(CategoryId),
    CONSTRAINT UQ_Enrolment UNIQUE (ParticipantId, CategoryId)
);
GO

CREATE TABLE dbo.Results (
    ResultId          INT IDENTITY(1,1)    PRIMARY KEY,
    EnrolmentId        INT                 NOT NULL UNIQUE,
    FinishTime          TIME               NULL,
    Position             INT               NULL,
    Status               NVARCHAR(20)      NOT NULL DEFAULT 'Finished' CHECK (Status IN ('Finished','DNF','DSQ')),
    CapturedByUserId     INT               NOT NULL,
    CapturedAt           DATETIME          NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Results_Enrolment FOREIGN KEY (EnrolmentId) REFERENCES dbo.Enrolments(EnrolmentId) ON DELETE CASCADE,
    CONSTRAINT FK_Results_CapturedBy FOREIGN KEY (CapturedByUserId) REFERENCES dbo.Users(UserId)
);
GO

INSERT INTO dbo.Users (FullName, Email, PasswordHash, Role) VALUES
('Thabo Nkosi',            'thabo.nkosi@raceday.co.za', 'HASHED_PASSWORD_1', 'Organiser'),
('Sarah van der Merwe',     'sarah.vdm@raceday.co.za',   'HASHED_PASSWORD_2', 'Organiser'),
('Lindiwe Dlamini',         'lindiwe.d@example.com',     'HASHED_PASSWORD_3', 'Participant'),
('James Botha',             'james.botha@example.com',   'HASHED_PASSWORD_4', 'Participant');
GO

INSERT INTO dbo.Events (OrganiserId, EventName, Description, EventDate, Location, Province, EventType) VALUES
(1, 'Cape Town Cycle Tour',  'Iconic 109km cycle race around the Cape Peninsula.',            '2026-03-08', 'Cape Town',   'Western Cape', 'Cycling'),
(1, 'Two Oceans Marathon',   'Ultra marathon known as the world''s most beautiful marathon.', '2026-04-04', 'Cape Town',   'Western Cape', 'Running'),
(2, 'Soweto Marathon',       'Marathon through the historic streets of Soweto.',              '2026-11-01', 'Johannesburg','Gauteng',      'Running');
GO

INSERT INTO dbo.Categories (EventId, CategoryName, DistanceKm, MaxParticipants, EntryFee) VALUES
(1, 'Individual Race',            109.00, 5000,  950.00),
(1, 'Mini Peloton (35km)',         35.00, 2000,  550.00),
(2, 'Ultra Marathon (56km)',       56.00, 8000,  850.00),
(2, 'Half Marathon (21km)',        21.10, 6000,  550.00),
(3, 'Full Marathon (42.2km)',      42.20, 10000, 400.00),
(3, '10km Fun Run',                10.00, 5000,  150.00);
GO

INSERT INTO dbo.EventRoutes (EventId, RouteName, DistanceKm, ElevationGainM, StartPoint, EndPoint, GpxFileUrl) VALUES
(1, 'Cape Peninsula Loop',    109.00, 1200, 'Green Point',        'Green Point',        NULL),
(2, 'Two Oceans Ultra Route',  56.00, 1500, 'UCT Rugby Fields',   'UCT Rugby Fields',   NULL),
(3, 'Soweto Streets Route',    42.20,  300, 'FNB Stadium',        'FNB Stadium',        NULL);
GO

INSERT INTO dbo.Enrolments (ParticipantId, CategoryId, BibNumber, Status) VALUES
(3, 1, 'CT1023', 'Confirmed'),
(4, 3, 'TO4521', 'Confirmed'),
(3, 5, 'SM7788', 'Confirmed'),
(4, 6, 'SM7789', 'Confirmed');
GO

INSERT INTO dbo.Results (EnrolmentId, FinishTime, Position, Status, CapturedByUserId) VALUES
(2, '04:15:32', 245, 'Finished', 1),
(3, '03:45:10', 102, 'Finished', 2);
GO