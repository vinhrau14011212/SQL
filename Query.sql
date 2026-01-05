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


SELECT 
    nv.TEN_NHAN_VIEN       AS N'Tên nhân viên bán',
    kh.TEN_KHACH_HANG      AS N'Tên khách hàng',
    cn.DIA_DIEM            AS N'Địa điểm thực hiện giao dịch',
    hd.TRI_GIA             AS N'Giá trị giao dịch'
FROM dbo.HoaDon hd
JOIN dbo.NhanVien nv 
    ON hd.MA_NV_BAN = nv.MA_NHAN_VIEN
JOIN dbo.KhachHang kh 
    ON hd.MA_KH = kh.MA_KH
JOIN dbo.ChiNhanh cn 
    ON hd.MA_CUA_HANG = cn.MA_CUA_HANG
JOIN dbo.SanPham sp 
    ON hd.MA_MAT_HANG = sp.MA_MAT_HANG
WHERE sp.MAT_HANG = 'Chain'
  AND YEAR(hd.NGAY_GIAO_DICH) = 2019
  AND hd.BUY_SELL = 'SELL';


SELECT
    cn.MA_CUA_HANG                         AS N'Mã cửa hàng',
    cn.DIA_DIEM                            AS N'Địa điểm cửa hàng',

    COUNT(DISTINCT hd.MA_KH)               AS N'Số lượng khách hàng',

    SUM(hd.TRI_GIA)                        AS N'Tổng trị giá mua',

    AVG(hd.TRI_GIA)                        AS N'Trị giá trung bình mỗi đơn',

    MIN(CASE 
            WHEN hd.TRI_GIA > 0 
            THEN hd.TRI_GIA 
        END)                               AS N'Trị giá đơn hàng nhỏ nhất',

    MAX(CASE 
            WHEN hd.TRI_GIA > 0 
            THEN hd.TRI_GIA 
        END)                               AS N'Trị giá đơn hàng lớn nhất'

FROM dbo.HoaDon hd
JOIN dbo.ChiNhanh cn
    ON hd.MA_CUA_HANG = cn.MA_CUA_HANG

WHERE hd.BUY_SELL = 'SELL'
  AND hd.NGAY_GIAO_DICH >= '2020-01-01'
  AND hd.NGAY_GIAO_DICH <  '2021-01-01'

GROUP BY
    cn.MA_CUA_HANG,
    cn.DIA_DIEM;


SELECT
    DAY(GETDATE())   AS [Ngay],
    MONTH(GETDATE()) AS [Thang],
    YEAR(GETDATE())  AS [Nam],
    kh.MA_KH         AS [Ma KH],
    kh.TEN_KHACH_HANG AS [Ten KH],
    CASE
        -- Chỉ cần còn 1 giao dịch mà (Ngày đến hạn + 2 năm) vẫn > thời điểm chạy query
        -- (bao gồm cả trường hợp Ngày đến hạn còn ở tương lai)
        WHEN MAX(CASE 
                    WHEN hd.DU_NO > 0 
                     AND DATEADD(YEAR, 2, hd.NGAY_DEN_HAN) > CAST(GETDATE() AS DATE)
                    THEN 1 ELSE 0
                 END) = 1
        THEN 'YES'
        ELSE NULL
    END AS [Future]
FROM dbo.KhachHang kh
JOIN dbo.HoaDon hd
    ON hd.MA_KH = kh.MA_KH
WHERE hd.DU_NO > 0   -- chỉ xét các giao dịch còn dư nợ
GROUP BY
    kh.MA_KH,
    kh.TEN_KHACH_HANG;
