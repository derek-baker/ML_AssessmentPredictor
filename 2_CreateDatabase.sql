USE [master]
GO

CREATE DATABASE [ML]
    CONTAINMENT = NONE
    ON PRIMARY ( 
        NAME = N'ML', 
        FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER01\MSSQL\DATA\ML.mdf', 
        SIZE = 8192KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 65536KB 
    )
    LOG ON ( 
        NAME = N'ML_log', 
        FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER01\MSSQL\DATA\ML_log.ldf' , 
        SIZE = 8192KB , 
        MAXSIZE = 2048GB , 
        FILEGROWTH = 65536KB 
    )
    WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO


IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
    EXEC [ML].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [ML] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [ML] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [ML] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [ML] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [ML] SET ARITHABORT OFF 
GO

ALTER DATABASE [ML] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [ML] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [ML] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [ML] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [ML] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [ML] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [ML] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [ML] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [ML] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [ML] SET  DISABLE_BROKER 
GO

ALTER DATABASE [ML] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [ML] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [ML] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [ML] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [ML] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [ML] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [ML] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [ML] SET RECOVERY FULL 
GO

ALTER DATABASE [ML] SET  MULTI_USER 
GO

ALTER DATABASE [ML] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [ML] SET DB_CHAINING OFF 
GO

ALTER DATABASE [ML] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [ML] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [ML] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [ML] SET QUERY_STORE = OFF
GO

ALTER DATABASE [ML] SET  READ_WRITE 
GO


