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
