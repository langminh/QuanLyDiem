USE [master]
GO
/****** Object:  Database [QuanLy_Diem]    Script Date: 30-May-18 1:07:41 AM ******/
CREATE DATABASE [QuanLy_Diem]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QuanLy_Diem', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\QuanLy_Diem.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'QuanLy_Diem_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\QuanLy_Diem_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [QuanLy_Diem] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QuanLy_Diem].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QuanLy_Diem] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QuanLy_Diem] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QuanLy_Diem] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QuanLy_Diem] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QuanLy_Diem] SET ARITHABORT OFF 
GO
ALTER DATABASE [QuanLy_Diem] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [QuanLy_Diem] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QuanLy_Diem] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QuanLy_Diem] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QuanLy_Diem] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QuanLy_Diem] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QuanLy_Diem] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QuanLy_Diem] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QuanLy_Diem] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QuanLy_Diem] SET  DISABLE_BROKER 
GO
ALTER DATABASE [QuanLy_Diem] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QuanLy_Diem] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QuanLy_Diem] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QuanLy_Diem] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QuanLy_Diem] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QuanLy_Diem] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QuanLy_Diem] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QuanLy_Diem] SET RECOVERY FULL 
GO
ALTER DATABASE [QuanLy_Diem] SET  MULTI_USER 
GO
ALTER DATABASE [QuanLy_Diem] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QuanLy_Diem] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QuanLy_Diem] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QuanLy_Diem] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [QuanLy_Diem] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'QuanLy_Diem', N'ON'
GO
ALTER DATABASE [QuanLy_Diem] SET QUERY_STORE = OFF
GO
USE [QuanLy_Diem]
GO
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [QuanLy_Diem]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GetClassIDNext]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[FN_GetClassIDNext]()
returns varchar(10)
as
begin
	declare @Idx int
	declare @MaLop varchar(50) = 'LOP0000001'
	set @Idx = 1;

	while(exists(select * from Lop where MaLop = @MaLop))
	begin
		set @Idx = @Idx + 1
		set @MaLop = 'LOP'+REPLICATE('0', 7-LEN(cast(@Idx as varchar))) + CAST(@Idx as varchar)
	end
	return @MaLop
end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetNameTeacher]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 create function [dbo].[fn_GetNameTeacher](@malop varchar(10))
 returns nvarchar(50)
 as
 begin
	declare @ten nvarchar(50)
	select @ten = CanBoGiaoVien.HoTen from Lop inner join CanBoGiaoVien on CanBoGiaoVien.MaCanBoGiaoVien = Lop.GiaoVienChuNhiem
 where MaLop = @malop
 return @ten
 end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetNextSubjectID]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_GetNextSubjectID]()
returns int
as
begin
	declare @t int
	SELECT @t =  IDENT_CURRENT ('MonHoc')
	return @t
end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetSchedulesTeach]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE function [dbo].[fn_GetSchedulesTeach]()
 returns @Schedules Table(MaLop varchar(10), TenLop nvarchar(50), HoTen nvarchar(50), TenMon nvarchar(50), NgayPhanCong datetime, MaCanBoGiaoVien varchar(10), MaMon int)
 as
 begin
	insert into @Schedules select Lop.MaLop, Lop.TenLop, CanBoGiaoVien.HoTen, MonHoc.TenMon, NgayPhanCong, CanBoGiaoVien.MaCanBoGiaoVien, MonHoc.MaMon from (PhanCongGiangDay inner join Lop on PhanCongGiangDay.MaLop = Lop.MaLop) inner join CanBoGiaoVien on PhanCongGiangDay.MaCanBoGiaoVien = CanBoGiaoVien.MaCanBoGiaoVien inner join MonHoc on MonHoc.MaMon = PhanCongGiangDay.MaMon
 group by Lop.MaLop, Lop.TenLop, CanBoGiaoVien.HoTen, MonHoc.TenMon, PhanCongGiangDay.NgayPhanCong, CanBoGiaoVien.MaCanBoGiaoVien, MonHoc.MaMon
 return
 end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetSchedulesTeachByClassID]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 create function [dbo].[fn_GetSchedulesTeachByClassID](@malop varchar(10))
 returns @Schedules Table(MaLop varchar(10), TenLop nvarchar(50), HoTen nvarchar(50), TenMon nvarchar(50), NgayPhanCong datetime)
 as
 begin
	insert into @Schedules select Lop.MaLop, Lop.TenLop, CanBoGiaoVien.HoTen, MonHoc.TenMon, NgayPhanCong from (PhanCongGiangDay inner join Lop on PhanCongGiangDay.MaLop = Lop.MaLop) inner join CanBoGiaoVien on PhanCongGiangDay.MaCanBoGiaoVien = CanBoGiaoVien.MaCanBoGiaoVien inner join MonHoc on MonHoc.MaMon = PhanCongGiangDay.MaMon
 where Lop.MaLop = @malop
 group by Lop.MaLop, Lop.TenLop, CanBoGiaoVien.HoTen, MonHoc.TenMon, PhanCongGiangDay.NgayPhanCong
 return
 end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetSchedulesTeachBySubjectID]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE function [dbo].[fn_GetSchedulesTeachBySubjectID](@mamon int)
 returns @Schedules Table(MaLop varchar(10), TenLop nvarchar(50), HoTen nvarchar(50), TenMon nvarchar(50), NgayPhanCong datetime)
 as
 begin
	insert into @Schedules select Lop.MaLop, Lop.TenLop, CanBoGiaoVien.HoTen, MonHoc.TenMon, NgayPhanCong from (PhanCongGiangDay inner join Lop on PhanCongGiangDay.MaLop = Lop.MaLop) inner join CanBoGiaoVien on PhanCongGiangDay.MaCanBoGiaoVien = CanBoGiaoVien.MaCanBoGiaoVien inner join MonHoc on MonHoc.MaMon = PhanCongGiangDay.MaMon
 where MonHoc.MaMon = @mamon
 group by Lop.MaLop, Lop.TenLop, CanBoGiaoVien.HoTen, MonHoc.TenMon, PhanCongGiangDay.NgayPhanCong
 return
 end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetSchedulesTeachByTeacherID]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 create function [dbo].[fn_GetSchedulesTeachByTeacherID](@magv varchar(10))
 returns @Schedules Table(MaLop varchar(10), TenLop nvarchar(50), HoTen nvarchar(50), TenMon nvarchar(50), NgayPhanCong datetime)
 as
 begin
	insert into @Schedules select Lop.MaLop, Lop.TenLop, CanBoGiaoVien.HoTen, MonHoc.TenMon, NgayPhanCong from (PhanCongGiangDay inner join Lop on PhanCongGiangDay.MaLop = Lop.MaLop) inner join CanBoGiaoVien on PhanCongGiangDay.MaCanBoGiaoVien = CanBoGiaoVien.MaCanBoGiaoVien inner join MonHoc on MonHoc.MaMon = PhanCongGiangDay.MaMon
 where CanBoGiaoVien.MaCanBoGiaoVien = @magv
 group by Lop.MaLop, Lop.TenLop, CanBoGiaoVien.HoTen, MonHoc.TenMon, PhanCongGiangDay.NgayPhanCong
 return
 end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetSchedulesTeachFillter]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  CREATE function [dbo].[fn_GetSchedulesTeachFillter](@tim nvarchar(50))
 returns @Schedules Table(MaLop varchar(10), TenLop nvarchar(50), HoTen nvarchar(50), TenMon nvarchar(50), NgayPhanCong datetime, MaCanBoGiaoVien varchar(10), MaMon int)
 as
 begin
	insert into @Schedules
 select Lop.MaLop, Lop.TenLop, CanBoGiaoVien.HoTen, MonHoc.TenMon, NgayPhanCong, CanBoGiaoVien.MaCanBoGiaoVien, MonHoc.MaMon 
 from (PhanCongGiangDay inner join Lop on PhanCongGiangDay.MaLop = Lop.MaLop) 
 inner join CanBoGiaoVien on PhanCongGiangDay.MaCanBoGiaoVien = CanBoGiaoVien.MaCanBoGiaoVien 
 inner join MonHoc on MonHoc.MaMon = PhanCongGiangDay.MaMon
 where Lop.MaLop like '%'+@tim+'%' or Lop.TenLop like '%'+@tim+'%' or CanBoGiaoVien.HoTen like '%'+@tim+'%' or CanBoGiaoVien.MaCanBoGiaoVien like '%'+@tim+'%' or MonHoc.TenMon like '%'+@tim+'%'
 group by Lop.MaLop, Lop.TenLop, CanBoGiaoVien.HoTen, MonHoc.TenMon, 
 PhanCongGiangDay.NgayPhanCong, CanBoGiaoVien.MaCanBoGiaoVien, MonHoc.MaMon
 return
 end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetScorceByIDSubject]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 create function [dbo].[fn_GetScorceByIDSubject](@mamon int)
 returns @Diem_HS Table(MaHocSinh varchar(10), HoTen nvarchar(50), TenMon nvarchar(50), DiemTB_Ky1 float, DiemTB_Ky2 float)
 as
 begin
 insert into @Diem_HS select HoSoHocSinh.MaHocSinh, HoSoHocSinh.HoTen, MonHoc.TenMon, DiemTB_Ky1, DiemTB_Ky2 from (Diem inner join  HoSoHocSinh on Diem.MaHocSinh = HoSoHocSinh.MaHocSinh) inner join MonHoc on MonHoc.MaMon = Diem.MaMonHoc
 where MonHoc.MaMon = @mamon
 group by HoSoHocSinh.MaHocSinh, HoSoHocSinh.HoTen, MonHoc.TenMon, Diem.DiemTB_Ky1, Diem.DiemTB_Ky2
 return
 end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetScorceStudent]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_GetScorceStudent](@maLop varchar(10), @maMon int)
returns @Scorce Table(MaHocSinh varchar(10), HoTen nvarchar(50),TenMon nvarchar(50), DiemTB_Ky1 float, DiemTB_Ky2 float, MaLop varchar(10),MaMon varchar(10) )
as
begin
	insert into @Scorce select  temp.MaHocSinh, temp.HoTen, temp.TenMon, temp.DiemTB_Ky1, temp.DiemTB_Ky2, temp.MaLop,temp.MaMon from temp
	inner join Lop on Lop.MaLop = temp.MaLop
	where temp.MaLop = @maLop and temp.MaMon = @maMon
	group by temp.MaLop, temp.MaHocSinh, temp.HoTen, temp.TenMon, temp.DiemTB_Ky1, temp.DiemTB_Ky2,temp.MaMon
return
end
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GetStudentIDNext]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[FN_GetStudentIDNext]()
returns varchar(10)
as
begin
	declare @Idx int
	declare @MaHS varchar(50) = 'HS00000001'
	set @Idx = 1;

	while(exists(select * from HoSoHocSinh where MaHocSinh = @MaHS))
	begin
		set @Idx = @Idx + 1
		set @MaHS = 'HS'+REPLICATE('0', 8-LEN(cast(@Idx as varchar))) + CAST(@Idx as varchar)
	end
	return @MaHS
end
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GetTeacherIDNext]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[FN_GetTeacherIDNext]()
returns varchar(10)
as
begin
	declare @Idx int
	declare @MaGV varchar(50) = 'GV00000001'
	set @Idx = 1;

	while(exists(select * from CanBoGiaoVien where MaCanBoGiaoVien = @MaGV))
	begin
		set @Idx = @Idx + 1
		set @MaGV = 'GV'+REPLICATE('0', 8-LEN(cast(@Idx as varchar))) + CAST(@Idx as varchar)
	end
	return @MaGV
end
GO
/****** Object:  UserDefinedFunction [dbo].[sb_GetScorceByIDStudent]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[sb_GetScorceByIDStudent] (@mahs varchar(10))
returns @Diem_HS Table(MaHocSinh varchar(10), HoTen nvarchar(50), TenMon nvarchar(50), DiemTB_Ky1 float, DiemTB_Ky2 float)
as
begin
insert into @Diem_HS select HoSoHocSinh.MaHocSinh, HoSoHocSinh.HoTen, MonHoc.TenMon, DiemTB_Ky1, DiemTB_Ky2 from (Diem inner join  HoSoHocSinh on Diem.MaHocSinh = HoSoHocSinh.MaHocSinh) inner join MonHoc on MonHoc.MaMon = Diem.MaMonHoc
 where HoSoHocSinh.MaHocSinh = @mahs
 group by HoSoHocSinh.MaHocSinh, HoSoHocSinh.HoTen, MonHoc.TenMon, Diem.DiemTB_Ky1, Diem.DiemTB_Ky2
 return
 end
GO
/****** Object:  Table [dbo].[MonHoc]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MonHoc](
	[MaMon] [int] IDENTITY(1,1) NOT NULL,
	[TenMon] [nvarchar](50) NOT NULL,
	[SoTiet] [int] NOT NULL,
 CONSTRAINT [PK_MonHoc] PRIMARY KEY CLUSTERED 
(
	[MaMon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Diem]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Diem](
	[MaHocSinh] [varchar](10) NOT NULL,
	[MaMonHoc] [int] NOT NULL,
	[DiemTB_Ky1] [float] NULL,
	[DiemTB_Ky2] [float] NULL,
 CONSTRAINT [PK_Diem] PRIMARY KEY CLUSTERED 
(
	[MaHocSinh] ASC,
	[MaMonHoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HoSoHocSinh]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HoSoHocSinh](
	[MaHocSinh] [varchar](10) NOT NULL,
	[HoTen] [nvarchar](50) NOT NULL,
	[NgaySinh] [datetime] NOT NULL,
	[GioiTinh] [int] NULL,
	[DiaChi] [nvarchar](250) NULL,
	[DiemVaoTruong] [float] NOT NULL,
	[HoTenBoMe] [nvarchar](50) NOT NULL,
	[SoDienThoai] [varchar](20) NULL,
	[MaLop] [varchar](10) NOT NULL,
 CONSTRAINT [PK_HoSoHocSinh] PRIMARY KEY CLUSTERED 
(
	[MaHocSinh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[temp]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[temp]
as

	select HoSoHocSinh.MaHocSinh, HoSoHocSinh.HoTen, HoSoHocSinh.MaLop, MonHoc.TenMon, MonHoc.MaMon, DiemTB_Ky1, DiemTB_Ky2
from (Diem inner join HoSoHocSinh on HoSoHocSinh.MaHocSinh = Diem.MaHocSinh) 
inner join MonHoc on MonHoc.MaMon = Diem.MaMonHoc 
GO
/****** Object:  Table [dbo].[CanBoGiaoVien]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CanBoGiaoVien](
	[MaCanBoGiaoVien] [varchar](10) NOT NULL,
	[HoTen] [nvarchar](50) NOT NULL,
	[DiaChi] [nvarchar](250) NULL,
	[SoDienThoai] [varchar](20) NULL,
	[TaiKhoan] [varchar](50) NOT NULL,
	[MatKhau] [varchar](50) NOT NULL,
	[LoaiTaiKhoan] [int] NOT NULL,
 CONSTRAINT [PK_CanBoGiaoVien] PRIMARY KEY CLUSTERED 
(
	[MaCanBoGiaoVien] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Lop]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lop](
	[MaLop] [varchar](10) NOT NULL,
	[TenLop] [nvarchar](50) NULL,
	[NienKhoa] [varchar](10) NULL,
	[SiSo] [int] NULL,
	[GiaoVienChuNhiem] [varchar](10) NULL,
 CONSTRAINT [PK_Lop] PRIMARY KEY CLUSTERED 
(
	[MaLop] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PhanCongGiangDay]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhanCongGiangDay](
	[MaLop] [varchar](10) NOT NULL,
	[MaMon] [int] NOT NULL,
	[MaCanBoGiaoVien] [varchar](10) NOT NULL,
	[NgayPhanCong] [datetime] NOT NULL,
 CONSTRAINT [PK_PhanCongGiangDay] PRIMARY KEY CLUSTERED 
(
	[MaLop] ASC,
	[MaMon] ASC,
	[MaCanBoGiaoVien] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[CanBoGiaoVien] ([MaCanBoGiaoVien], [HoTen], [DiaChi], [SoDienThoai], [TaiKhoan], [MatKhau], [LoaiTaiKhoan]) VALUES (N'GV00000001', N'Nguyen Van D', N'Ha Noi', N'01666476535', N'GV_001', N'gv01', 2)
INSERT [dbo].[CanBoGiaoVien] ([MaCanBoGiaoVien], [HoTen], [DiaChi], [SoDienThoai], [TaiKhoan], [MatKhau], [LoaiTaiKhoan]) VALUES (N'GV00000002', N'Nguyen Thi F', N'Hai Duong', N'0977206532', N'GV_002', N'gv02', 2)
INSERT [dbo].[CanBoGiaoVien] ([MaCanBoGiaoVien], [HoTen], [DiaChi], [SoDienThoai], [TaiKhoan], [MatKhau], [LoaiTaiKhoan]) VALUES (N'GV00000003', N'Trieu Thi R', N'Hung Yen', N'01666476535', N'GV_003', N'123', 1)
INSERT [dbo].[CanBoGiaoVien] ([MaCanBoGiaoVien], [HoTen], [DiaChi], [SoDienThoai], [TaiKhoan], [MatKhau], [LoaiTaiKhoan]) VALUES (N'GV00000004', N'admin', N'test', N'test', N'admin', N'admin', 1)
INSERT [dbo].[Diem] ([MaHocSinh], [MaMonHoc], [DiemTB_Ky1], [DiemTB_Ky2]) VALUES (N'HS00000001', 1, 9, 6)
INSERT [dbo].[Diem] ([MaHocSinh], [MaMonHoc], [DiemTB_Ky1], [DiemTB_Ky2]) VALUES (N'HS00000001', 2, 5.5, 7)
INSERT [dbo].[Diem] ([MaHocSinh], [MaMonHoc], [DiemTB_Ky1], [DiemTB_Ky2]) VALUES (N'HS00000001', 3, 7, 6.5)
INSERT [dbo].[Diem] ([MaHocSinh], [MaMonHoc], [DiemTB_Ky1], [DiemTB_Ky2]) VALUES (N'HS00000002', 1, 7, 9)
INSERT [dbo].[Diem] ([MaHocSinh], [MaMonHoc], [DiemTB_Ky1], [DiemTB_Ky2]) VALUES (N'HS00000002', 2, 8, 6)
INSERT [dbo].[Diem] ([MaHocSinh], [MaMonHoc], [DiemTB_Ky1], [DiemTB_Ky2]) VALUES (N'HS00000002', 3, 5.5, 7)
INSERT [dbo].[HoSoHocSinh] ([MaHocSinh], [HoTen], [NgaySinh], [GioiTinh], [DiaChi], [DiemVaoTruong], [HoTenBoMe], [SoDienThoai], [MaLop]) VALUES (N'HS00000001', N'Nguyen Van A', CAST(N'2005-10-29T00:00:00.000' AS DateTime), 1, N'Ha Noi', 19, N'Nguyen Van B', N'0977206532', N'LOP0000001')
INSERT [dbo].[HoSoHocSinh] ([MaHocSinh], [HoTen], [NgaySinh], [GioiTinh], [DiaChi], [DiemVaoTruong], [HoTenBoMe], [SoDienThoai], [MaLop]) VALUES (N'HS00000002', N'Nguyen Thi K', CAST(N'2005-05-02T00:00:00.000' AS DateTime), 0, N'Bac Ninh', 19.5, N'Trieu Thi D', N'0977206532', N'LOP0000001')
INSERT [dbo].[HoSoHocSinh] ([MaHocSinh], [HoTen], [NgaySinh], [GioiTinh], [DiaChi], [DiemVaoTruong], [HoTenBoMe], [SoDienThoai], [MaLop]) VALUES (N'HS00000003', N'Nguyen Thi F', CAST(N'2018-03-19T00:00:00.000' AS DateTime), 0, N'Bac Ninh', 19.5, N'Trieu Thi D', N'0977206532', N'LOP0000001')
INSERT [dbo].[Lop] ([MaLop], [TenLop], [NienKhoa], [SiSo], [GiaoVienChuNhiem]) VALUES (N'LOP0000001', N'Lop 10A1', N'2005-2008', 32, N'GV00000001')
INSERT [dbo].[Lop] ([MaLop], [TenLop], [NienKhoa], [SiSo], [GiaoVienChuNhiem]) VALUES (N'LOP0000002', N'Lop 10A2', N'2005-2008', 28, N'GV00000002')
SET IDENTITY_INSERT [dbo].[MonHoc] ON 

INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [SoTiet]) VALUES (1, N'Toan', 35)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [SoTiet]) VALUES (2, N'Van Anh', 35)
INSERT [dbo].[MonHoc] ([MaMon], [TenMon], [SoTiet]) VALUES (3, N'Anh', 35)
SET IDENTITY_INSERT [dbo].[MonHoc] OFF
INSERT [dbo].[PhanCongGiangDay] ([MaLop], [MaMon], [MaCanBoGiaoVien], [NgayPhanCong]) VALUES (N'LOP0000001', 1, N'GV00000001', CAST(N'2018-05-22T00:00:00.000' AS DateTime))
INSERT [dbo].[PhanCongGiangDay] ([MaLop], [MaMon], [MaCanBoGiaoVien], [NgayPhanCong]) VALUES (N'LOP0000001', 2, N'GV00000002', CAST(N'2018-05-21T00:00:00.000' AS DateTime))
INSERT [dbo].[PhanCongGiangDay] ([MaLop], [MaMon], [MaCanBoGiaoVien], [NgayPhanCong]) VALUES (N'LOP0000001', 3, N'GV00000003', CAST(N'2018-05-21T00:00:00.000' AS DateTime))
INSERT [dbo].[PhanCongGiangDay] ([MaLop], [MaMon], [MaCanBoGiaoVien], [NgayPhanCong]) VALUES (N'LOP0000002', 1, N'GV00000002', CAST(N'2018-05-22T00:00:00.000' AS DateTime))
INSERT [dbo].[PhanCongGiangDay] ([MaLop], [MaMon], [MaCanBoGiaoVien], [NgayPhanCong]) VALUES (N'LOP0000002', 1, N'GV00000003', CAST(N'2018-05-22T00:00:00.000' AS DateTime))
INSERT [dbo].[PhanCongGiangDay] ([MaLop], [MaMon], [MaCanBoGiaoVien], [NgayPhanCong]) VALUES (N'LOP0000002', 2, N'GV00000002', CAST(N'2018-05-22T00:00:00.000' AS DateTime))
INSERT [dbo].[PhanCongGiangDay] ([MaLop], [MaMon], [MaCanBoGiaoVien], [NgayPhanCong]) VALUES (N'LOP0000002', 3, N'GV00000002', CAST(N'2018-05-22T00:00:00.000' AS DateTime))
ALTER TABLE [dbo].[Diem] ADD  CONSTRAINT [DF_Diem_DiemTB_Ky1]  DEFAULT ((0)) FOR [DiemTB_Ky1]
GO
ALTER TABLE [dbo].[Diem] ADD  CONSTRAINT [DF_Diem_DiemTB_Ky2]  DEFAULT ((0)) FOR [DiemTB_Ky2]
GO
ALTER TABLE [dbo].[Diem]  WITH CHECK ADD  CONSTRAINT [FK_Diem_HoSoHocSinh] FOREIGN KEY([MaHocSinh])
REFERENCES [dbo].[HoSoHocSinh] ([MaHocSinh])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Diem] CHECK CONSTRAINT [FK_Diem_HoSoHocSinh]
GO
ALTER TABLE [dbo].[Diem]  WITH CHECK ADD  CONSTRAINT [FK_Diem_MonHoc] FOREIGN KEY([MaMonHoc])
REFERENCES [dbo].[MonHoc] ([MaMon])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Diem] CHECK CONSTRAINT [FK_Diem_MonHoc]
GO
ALTER TABLE [dbo].[HoSoHocSinh]  WITH CHECK ADD  CONSTRAINT [FK_HoSoHocSinh_Lop] FOREIGN KEY([MaLop])
REFERENCES [dbo].[Lop] ([MaLop])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[HoSoHocSinh] CHECK CONSTRAINT [FK_HoSoHocSinh_Lop]
GO
ALTER TABLE [dbo].[Lop]  WITH CHECK ADD  CONSTRAINT [FK_Lop_CanBoGiaoVien] FOREIGN KEY([GiaoVienChuNhiem])
REFERENCES [dbo].[CanBoGiaoVien] ([MaCanBoGiaoVien])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Lop] CHECK CONSTRAINT [FK_Lop_CanBoGiaoVien]
GO
ALTER TABLE [dbo].[PhanCongGiangDay]  WITH CHECK ADD  CONSTRAINT [FK_PhanCongGiangDay_CanBoGiaoVien] FOREIGN KEY([MaCanBoGiaoVien])
REFERENCES [dbo].[CanBoGiaoVien] ([MaCanBoGiaoVien])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PhanCongGiangDay] CHECK CONSTRAINT [FK_PhanCongGiangDay_CanBoGiaoVien]
GO
ALTER TABLE [dbo].[PhanCongGiangDay]  WITH CHECK ADD  CONSTRAINT [FK_PhanCongGiangDay_Lop] FOREIGN KEY([MaLop])
REFERENCES [dbo].[Lop] ([MaLop])
GO
ALTER TABLE [dbo].[PhanCongGiangDay] CHECK CONSTRAINT [FK_PhanCongGiangDay_Lop]
GO
ALTER TABLE [dbo].[PhanCongGiangDay]  WITH CHECK ADD  CONSTRAINT [FK_PhanCongGiangDay_MonHoc] FOREIGN KEY([MaMon])
REFERENCES [dbo].[MonHoc] ([MaMon])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PhanCongGiangDay] CHECK CONSTRAINT [FK_PhanCongGiangDay_MonHoc]
GO
/****** Object:  StoredProcedure [dbo].[db_LayDanhSachHocSinh]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE proc [dbo].[db_LayDanhSachHocSinh]
 @magv varchar(10)
 as
 begin
 select HoSoHocSinh.MaHocSinh, HoSoHocSinh.HoTen, HoSoHocSinh.NgaySinh, HoSoHocSinh.DiaChi, HoSoHocSinh.SoDienThoai from HoSoHocSinh
 inner join Lop on Lop.MaLop = HoSoHocSinh.MaLop inner join CanBoGiaoVien
 on Lop.GiaoVienChuNhiem = CanBoGiaoVien.MaCanBoGiaoVien
 where CanBoGiaoVien.MaCanBoGiaoVien = @magv
 group by HoSoHocSinh.MaHocSinh, HoSoHocSinh.HoTen, HoSoHocSinh.NgaySinh, HoSoHocSinh.DiaChi, HoSoHocSinh.SoDienThoai
end
GO
/****** Object:  StoredProcedure [dbo].[FC_GetClassIDNext]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[FC_GetClassIDNext]
@MaLop varchar(10) out
as
begin
	declare @Idx int
	set @MaLop = 'LOP0000001'
	set @Idx = 1;

	while(exists(select * from [Lop] where MaLop = @MaLop))
	begin
		set @Idx = @Idx + 1
		set @MaLop = 'US'+REPLICATE('0', 7-LEN(cast(@Idx as varchar))) + CAST(@Idx as varchar)
	end
	return @MaLop
end
GO
/****** Object:  StoredProcedure [dbo].[sb_AddNewScheduleTeach]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sb_AddNewScheduleTeach]
 @malop varchar(10), @magv varchar(10), @mamon int, @ngayphancong datetime
 as
 begin
	if(not exists(select * from PhanCongGiangDay where MaLop = @malop and MaCanBoGiaoVien = @magv and MaMon = @mamon))
	begin
		INSERT INTO [dbo].[PhanCongGiangDay]
           ([MaLop]
           ,[MaMon]
           ,[MaCanBoGiaoVien]
           ,[NgayPhanCong])
     VALUES
           (@malop
           ,@mamon
           ,@magv
           ,@ngayphancong)
	end
 end
GO
/****** Object:  StoredProcedure [dbo].[sb_GetInfoStudent]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sb_GetInfoStudent]
@maHS varchar(10)
as
begin
	SELECT * FROM dbo.HoSoHocSinh WHERE MaHocSinh = @maHS
end
GO
/****** Object:  StoredProcedure [dbo].[sb_GetListStudentByClassID]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE proc [dbo].[sb_GetListStudentByClassID]
 @malop varchar(10)
 as
 begin
 select MaHocSinh, HoTen, NgaySinh, case
 when GioiTinh = 1 Then N'Nam'
 when GioiTinh = 0 Then N'Nữ'
 end as 'GioiTinh'
 , DiaChi, DiemVaoTruong, HoTenBoMe, SoDienThoai, Lop.TenLop
 from HoSoHocSinh inner join Lop on HoSoHocSinh.MaLop = Lop.MaLop
 where Lop.MaLop = @malop
 end
GO
/****** Object:  StoredProcedure [dbo].[sb_GetListTeacherByClassID]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 create proc [dbo].[sb_GetListTeacherByClassID]
 @malop varchar(10)
 as
 begin
 select CanBoGiaoVien.MaCanBoGiaoVien, HoTen, [SoDienThoai], MonHoc.TenMon, PhanCongGiangDay.NgayPhanCong
 from CanBoGiaoVien inner join PhanCongGiangDay on PhanCongGiangDay.MaCanBoGiaoVien = CanBoGiaoVien.MaCanBoGiaoVien
 inner join MonHoc on MonHoc.MaMon = PhanCongGiangDay.MaMon
 where PhanCongGiangDay.MaLop = @malop
 group by CanBoGiaoVien.MaCanBoGiaoVien, CanBoGiaoVien.HoTen, CanBoGiaoVien.SoDienThoai, 
 MonHoc.TenMon, PhanCongGiangDay.NgayPhanCong
 end
GO
/****** Object:  StoredProcedure [dbo].[sb_GetNameTeacher]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 create proc [dbo].[sb_GetNameTeacher] @malop varchar(10)
 as
 begin
	select CanBoGiaoVien.HoTen from Lop inner join CanBoGiaoVien on CanBoGiaoVien.MaCanBoGiaoVien = Lop.GiaoVienChuNhiem
 where MaLop = @malop
 end
GO
/****** Object:  StoredProcedure [dbo].[sb_UpdateClass]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sb_UpdateClass]
@malop varchar(10), @tenlop nvarchar(50), @nienkhoa varchar(10), @siso int, @giaovien_cn varchar(10)
as
begin
	UPDATE [dbo].[Lop]
   SET [TenLop] = @tenlop
      ,[NienKhoa] = @nienkhoa
      ,[SiSo] = @siso
      ,[GiaoVienChuNhiem] = @giaovien_cn
 WHERE MaLop = @malop
end

GO
/****** Object:  StoredProcedure [dbo].[sb_UpdateScorce]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sb_UpdateScorce]
@mahs varchar(10), @mamon int, @diemky1 float, @diemky2 float
as
begin
	UPDATE [dbo].[Diem] SET [DiemTB_Ky1] = @diemky1 ,[DiemTB_Ky2] = @diemky2 WHERE [MaHocSinh] = @mahs and [MaMonHoc] = @mamon
end 
GO
/****** Object:  StoredProcedure [dbo].[sb_UpdateStudent]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sb_UpdateStudent]
@mahs varchar(10), @hoten nvarchar(50), @ngaysinh datetime, @gioitinh bit, @diachi nvarchar(250), @diemvaotruong float, @hotenbome nvarchar(50), @sodienthoai varchar(20), @malop varchar(10)
as
begin
	UPDATE [dbo].[HoSoHocSinh] SET [HoTen] = @hoten ,[NgaySinh] = @ngaysinh ,[GioiTinh] = @gioitinh ,[DiaChi] = @diachi ,[DiemVaoTruong] = @diemvaotruong ,[HoTenBoMe] = @hotenbome ,[SoDienThoai] = @sodienthoai ,[MaLop] = @malop WHERE MaHocSinh = @mahs
end
GO
/****** Object:  StoredProcedure [dbo].[sb_UpdateSubject]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sb_UpdateSubject]
@mamon int, @tenmon nvarchar(50), @sotiet int
as
begin
	UPDATE [dbo].[MonHoc]
   SET [TenMon] = @tenmon
      ,[SoTiet] = @sotiet
 WHERE MaMon = @mamon
end
GO
/****** Object:  StoredProcedure [dbo].[sb_UpdateTeacher]    Script Date: 30-May-18 1:07:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sb_UpdateTeacher]
@magv varchar(10), @tengv nvarchar(50), @diachi nvarchar(250), @sdt varchar(20), @taikhoan varchar(50), @matkhau varchar(50), @loai int
as
begin
UPDATE [dbo].[CanBoGiaoVien]
   SET [HoTen] = @tengv
      ,[DiaChi] = @diachi
      ,[SoDienThoai] = @sdt
      ,[TaiKhoan] = @taikhoan
      ,[MatKhau] = @matkhau
      ,[LoaiTaiKhoan] = @loai
 WHERE MaCanBoGiaoVien = @magv
end

GO
USE [master]
GO
ALTER DATABASE [QuanLy_Diem] SET  READ_WRITE 
GO
