SELECT
    MA_HOA_DON,
    MA_NV_BAN,
    MA_KH,
    TRI_GIA,
    TRI_GIA * PHAN_TRAM_HOA_HONG / 100.0 AS SO_TIEN_HOA_HONG,
    DU_NO
FROM dbo.HoaDon
WHERE NGAY_GIAO_DICH >= '20200101'
  AND NGAY_GIAO_DICH <  '20200401'
  AND (
        TRI_GIA * PHAN_TRAM_HOA_HONG / 100.0 > 50000000
        OR DU_NO > 30000000
      );



SELECT TOP 10
    MA_CUA_HANG,      -- Store ID
    MA_NV_BAN,        -- Sales employee ID
    MA_MAT_HANG,      -- Product ID
    TRI_GIA           -- Transaction value
FROM dbo.HoaDon
WHERE MA_KH = 'MKH303217'
  AND MA_CUA_HANG = 'STORE 1'
  AND NGAY_DEN_HAN > DATEADD(MONTH, 12, NGAY_GIAO_DICH)   -- strictly > 12 months
ORDER BY NGAY_GIAO_DICH DESC, MA_HOA_DON DESC;


SELECT TOP 10 
    nv.TEN_NHAN_VIEN
FROM 
    dbo.HoaDon hd
JOIN 
    dbo.NhanVien nv ON hd.MA_NV_BAN = nv.MA_NHAN_VIEN
WHERE 
    hd.TRI_GIA > 100000000
ORDER BY 
    hd.NGAY_GIAO_DICH DESC;


SELECT COUNT(*) AS SoLuongKhachHang
FROM dbo.KhachHang kh
WHERE kh.GIOI_TINH = 'Ms' 
  AND kh.DIA_CHI_KH LIKE N'%Quảng Bình%'
  AND kh.MA_KH NOT IN (SELECT DISTINCT MA_KH FROM dbo.HoaDon);
