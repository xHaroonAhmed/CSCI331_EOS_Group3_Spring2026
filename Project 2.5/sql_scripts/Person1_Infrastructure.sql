USE [PrestigeCars]
GO

PRINT '=============================================='
PRINT 'Person 1 - Infrastructure Setup Starting...'
PRINT '=============================================='
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Process')
BEGIN
    EXEC('CREATE SCHEMA [Process]')
    PRINT 'Schema [Process] created.'
END
ELSE
    PRINT 'Schema [Process] already exists - skipping.'
GO

IF OBJECT_ID('Process.WorkflowSteps', 'U') IS NOT NULL
    DROP TABLE Process.WorkflowSteps;
GO

CREATE TABLE [Process].[WorkflowSteps]
(
    [WorkFlowStepKey]           INT             IDENTITY(1,1) NOT NULL,
    [WorkFlowStepDescription]   NVARCHAR(100)   NOT NULL,
    [WorkFlowStepTableRowCount] INT             NULL,
    [StartingDateTime]          DATETIME2(7)    NOT NULL DEFAULT SYSDATETIME(),
    [EndingDateTime]            DATETIME2(7)    NULL,
    [ClassTime]                 NCHAR(5)        NULL,
    [UserAuthorizationKey]      INT             NOT NULL,

    CONSTRAINT [PK_WorkflowSteps] PRIMARY KEY CLUSTERED
    (
        [WorkFlowStepKey] ASC
    )
)
GO

PRINT 'Table [Process].[WorkflowSteps] created.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'DbSecurity')
BEGIN
    EXEC('CREATE SCHEMA [DbSecurity]')
    PRINT 'Schema [DbSecurity] created.'
END
ELSE
    PRINT 'Schema [DbSecurity] already exists - skipping.'
GO

IF OBJECT_ID('DbSecurity.UserAuthorization', 'U') IS NOT NULL
    DROP TABLE DbSecurity.UserAuthorization;
GO

CREATE TABLE [DbSecurity].[UserAuthorization]
(
    [UserAuthorizationKey]  INT             IDENTITY(1,1) NOT NULL,
    [ClassTime]             NCHAR(5)        NULL DEFAULT '10:15',
    [IndividualProject]     NVARCHAR(60)    NULL DEFAULT 'PROJECT 2.5',
    [GroupMemberLastName]   NVARCHAR(35)    NOT NULL,
    [GroupMemberFirstName]  NVARCHAR(25)    NOT NULL,
    [GroupName]             NVARCHAR(20)    NOT NULL DEFAULT 'Group 1',
    [DateAdded]             DATETIME2(7)    NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT [PK_UserAuthorization] PRIMARY KEY CLUSTERED
    (
        [UserAuthorizationKey] ASC
    )
)
GO

PRINT 'Table [DbSecurity].[UserAuthorization] created.'
GO

ALTER TABLE [Process].[WorkflowSteps]
    ADD CONSTRAINT [FK_WorkflowSteps_UserAuthorization]
    FOREIGN KEY ([UserAuthorizationKey])
    REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]);
GO

PRINT 'Foreign key added.'
GO

INSERT INTO [DbSecurity].[UserAuthorization]
    ([GroupMemberLastName], [GroupMemberFirstName], [GroupName], [IndividualProject])
VALUES
    ('Laboy',   'Andrew',   'Group 1', 'PROJECT 2.5 - Person 1: Project Manager'),
    ('Ahmed',   'Haroon',   'Group 1', 'PROJECT 2.5 - Person 2: UDT Architect'),
    ('Gao',     'Zhenkai',  'Group 1', 'PROJECT 2.5 - Person 3: Customer/Sales'),
    ('Karim',   'Azm',      'Group 1', 'PROJECT 2.5 - Person 4: Make/Model/Stock'),
    ('Islam',   'Kazi',     'Group 1', 'PROJECT 2.5 - Person 5: Country/SalesDetails'),
    ('Awad',    'Mohamed',  'Group 1', 'PROJECT 2.5 - Person 6: Views Part 1'),
    ('Cange',   'Ralph',    'Group 1', 'PROJECT 2.5 - Person 7: Views Part 2');
GO

PRINT 'Team members inserted.'
GO

DECLARE @UserKey INT
SELECT @UserKey = UserAuthorizationKey 
FROM DbSecurity.UserAuthorization 
WHERE GroupMemberFirstName = 'Andrew' 
  AND GroupMemberLastName = 'Laboy';

INSERT INTO [Process].[WorkflowSteps]
    ([WorkFlowStepDescription], [WorkFlowStepTableRowCount], [UserAuthorizationKey], [ClassTime])
VALUES
    ('Created Process schema', 1, @UserKey, '10:15'),
    ('Created Process.WorkflowSteps table', 1, @UserKey, '10:15'),
    ('Created DbSecurity schema', 1, @UserKey, '10:15'),
    ('Created DbSecurity.UserAuthorization table', 7, @UserKey, '10:15'),
    ('Added all 7 team members', 7, @UserKey, '10:15');
GO

PRINT '--- UserAuthorization Table ---'
SELECT * FROM [DbSecurity].[UserAuthorization]
GO

PRINT '--- WorkflowSteps Table ---'
SELECT * FROM [Process].[WorkflowSteps]
GO
