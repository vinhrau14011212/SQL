CREATE TABLE Study.BAND (
    BAND_ID           CHAR(2)        NOT NULL,   -- ví dụ: S9
    MIN_SALARY        INT            NOT NULL,   -- ví dụ: 20000000
    MAX_SALARY        INT            NOT NULL,   -- ví dụ: 30000000
    EXPERIENCE_YEAR   INT            NOT NULL,   -- ví dụ: 2
    BENEFIT           INT            NOT NULL,   -- ví dụ: 1000000
    INSURANCE_LEVEL   NVARCHAR(20)   NOT NULL,   -- ví dụ: Normal

    CONSTRAINT PK_BAND PRIMARY KEY (BAND_ID),

    -- Điều kiện theo yêu cầu trong bảng:
    CONSTRAINT CK_BAND_MIN_SALARY_GT_5M CHECK (MIN_SALARY > 5000000),
    CONSTRAINT CK_BAND_MAX_SALARY_LT_1B CHECK (MAX_SALARY < 1000000000),
    CONSTRAINT CK_BAND_SALARY_ORDER     CHECK (MAX_SALARY >= MIN_SALARY),
    CONSTRAINT CK_BAND_EXP_POSITIVE     CHECK (EXPERIENCE_YEAR >= 0),
    CONSTRAINT CK_BAND_BENEFIT_NONNEG   CHECK (BENEFIT >= 0),

    -- Format BAND_ID kiểu "S9" (1 chữ + 1 số)
    CONSTRAINT CK_BAND_ID_FORMAT CHECK (BAND_ID LIKE '[A-Z][0-9]')
);
GO
/* ========== 2) TABLE: EMPLOYEE ========== */
CREATE TABLE Study.EMPLOYEE (
    EMPLOYEE_ID            CHAR(9)         NOT NULL,   -- ví dụ: EMP000010 (3 + 6 số)
    EMPLOYEE_NAME          NVARCHAR(100)   NOT NULL,   -- ví dụ: Lương Sơn
    AGE                    INT             NOT NULL,   -- ví dụ: 29 (số nguyên dương)
    DOB                    DATE            NOT NULL,   -- ví dụ: 2020-12-28
    EMAIL                  NVARCHAR(254)   NOT NULL,   -- ví dụ: abc@gmail.com.vn
    ADDRESS                NVARCHAR(255)   NOT NULL,   -- ví dụ: Thành Công, Hà Nội
    CERTIFICATE            NVARCHAR(50)    NOT NULL,   -- ví dụ: Đại Học
    INCOME_ACCOUNT_NUMBER  BIGINT          NOT NULL,   -- ví dụ: 1903330000000
    DEPARTMENT_ID          CHAR(5)         NOT NULL,   -- ví dụ: IT001
    ROLE_ID                NVARCHAR(20)    NOT NULL,   -- ví dụ: CGCC (không rõ format cố định -> để linh hoạt)
    BAND_ID                CHAR(2)         NOT NULL,   -- ví dụ: S9

    CONSTRAINT PK_EMPLOYEE PRIMARY KEY (EMPLOYEE_ID),

    -- Mỗi dòng chứa giá trị duy nhất (PK đã đảm bảo EMPLOYEE_ID là duy nhất)

    -- Điều kiện theo yêu cầu:
    CONSTRAINT CK_EMPLOYEE_AGE_POSITIVE CHECK (AGE > 0),

    -- Format EMPLOYEE_ID "EMP" + 6 chữ số
    CONSTRAINT CK_EMPLOYEE_ID_FORMAT CHECK (EMPLOYEE_ID LIKE 'EMP[0-9][0-9][0-9][0-9][0-9][0-9]'),

    -- Email basic format check (không hoàn hảo 100% nhưng đủ theo bài)
    CONSTRAINT CK_EMPLOYEE_EMAIL_FORMAT CHECK (EMAIL LIKE '%_@_%._%'),

    -- Số tài khoản không âm (dữ liệu mẫu là số lớn)
    CONSTRAINT CK_EMPLOYEE_ACC_NONNEG CHECK (INCOME_ACCOUNT_NUMBER >= 0),

    -- FK sang BAND
    CONSTRAINT FK_EMPLOYEE_BAND FOREIGN KEY (BAND_ID) REFERENCES Study.BAND(BAND_ID)
);
GO