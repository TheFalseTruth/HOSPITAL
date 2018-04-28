create table DEPARTMENT (
  DID     INT           PRIMARY KEY,
  DTitle  VARCHAR(10)   NOT NULL      UNIQUE,
  EID     VARCHAR(7)    NOT NULL      UNIQUE      -- ID of the Dean
);
create table EMPLOYEE (
  EID     VARCHAR(7)    PRIMARY KEY,
  EFname  VARCHAR(15)   NOT NULL,
  ELname  VARCHAR(15),
  EDoB    DATE          NOT NULL, -- Employee's date of birth
  EGenre  CHAR(1)       NOT NULL, -- M for male, F for Female
  ESpeciality CHAR(3)   NOT NULL, -- DOC for doctor, NUR for nurse
  EAddress VARCHAR(30)  NOT NULL, -- Address of employee
  EStartDate DATE       NOT NULL, -- Start working date
  DID      INT,
  CONSTRAINT FK_EmpDID FOREIGN KEY (DID) REFERENCES DEPARTMENT(DID)
  ON DELETE CASCADE-- Set DID as Foreign key
);

alter table DEPARTMENT
add foreign key (EID) REFERENCES EMPLOYEE(EID); -- Set EID as FOREIGN KEY for DEPARTMENT

create table EMP_Phone (
  EID     VARCHAR(7)    NOT NULL,
  EPhone  VARCHAR(15)   NOT NULL,
  CONSTRAINT FK_EmpPhone FOREIGN KEY (EID) REFERENCES EMPLOYEE(EID) ON DELETE CASCADE,
  PRIMARY KEY (EID, EPhone)   -- EID and EPhone are composite PK
);
create table DOCTOR (
  EID_Doc  VARCHAR(7)  PRIMARY KEY,
  CONSTRAINT FK_EmpDoc  FOREIGN KEY (EID_Doc) REFERENCES EMPLOYEE(EID) ON DELETE CASCADE
);
create table NURSE (
  EID_Nur  VARCHAR(7)  PRIMARY KEY,
  CONSTRAINT FK_EmpNur  FOREIGN KEY (EID_Nur) REFERENCES EMPLOYEE(EID) ON DELETE CASCADE
);
create table PATIENT (
  PID       VARCHAR(7)    PRIMARY KEY,
  PFname    VARCHAR(15)   NOT NULL,
  PLname    VARCHAR(15)   NOT NULL,
  PDoB      DATE          NOT NULL, -- Patient's date of birth
  PGenre    CHAR(1)       NOT NULL, -- M for male, F for Female
  PPhone    VARCHAR(15)   NOT NULL,
  PAddress  VARCHAR(30)   NOT NULL -- Address of Patient
);

create table OUTPATIENT (
  PID_Out   VARCHAR(7)    PRIMARY KEY,
  EID_Doc   INT           NOT NULL,
  CONSTRAINT FK_PatDoc  FOREIGN KEY (EID_Doc) REFERENCES DOCTOR(EID_Doc) ON DELETE CASCADE,
  CONSTRAINT FK_PatOut  FOREIGN KEY (PID_Out) REFERENCES PATIENT(PID) ON DELETE CASCADE
);
create table  INPATIENT (
  PID_In          VARCHAR(7)    PRIMARY KEY,
  PAdmissionDate  DATE          NOT NULL,
  PDischargeDate  DATE, --May be NULL because the patient may be there forevery LOL
  PDiagnosis      TEXT, --May be NULL because the patient hasn't take any treatment?
  PSickroom       VARCHAR(5)    NOT NULL,
  PFee            INT           NOT NULL, -- No fee will be 0
  EID_Doc         VARCHAR(7),
  EID_Nur         VARCHAR(7),
  CONSTRAINT FK_InPatDoc  FOREIGN KEY (EID_Doc) REFERENCES DOCTOR(EID_Doc) ON DELETE CASCADE,
  CONSTRAINT FK_InPatNur  FOREIGN KEY (EID_Nur) REFERENCES NURSE(EID_Nur) ON DELETE CASCADE
);
create table EXAMINATION (
  EID_Doc         VARCHAR(7),
  PID_Out         VARCHAR(7),
  ExID            VARCHAR(7),
  ExDate          DATE        NOT NULL,
  ExFee           INT         NOT NULL,
  ExDiagnosis     TEXT,
  ExSecondExaminationDate DATE, -- Long name, may be NULL because there is no need for second exam
  CONSTRAINT FK_ExDoc  FOREIGN KEY (EID_Doc) REFERENCES DOCTOR(EID_Doc) ON DELETE CASCADE,
  CONSTRAINT FK_ExPat  FOREIGN KEY (PID_Out) REFERENCES OUTPATIENT(PID_Out) ON DELETE CASCADE,
  PRIMARY KEY (EID_Doc, PID_Out, ExID)
);
create table TREATMENT (
  EID_Doc         VARCHAR(7),
  PID_In          VARCHAR(7),
  TrID            VARCHAR(7),
  TrStart         DATE        NOT NULL,
  TrEnd           DATE, -- Can be NULL because the treatment hasn't performed
  TrResult        TEXT, -- Same
  CONSTRAINT FK_TrDoc  FOREIGN KEY (EID_Doc) REFERENCES DOCTOR(EID_Doc) ON DELETE CASCADE,
  CONSTRAINT FK_TrPat  FOREIGN KEY (PID_In) REFERENCES INPATIENT(PID_In) ON DELETE CASCADE,
  PRIMARY KEY (EID_Doc, PID_In, TrID)
);

create table MEDICATION (
  MID     VARCHAR(7)   PRIMARY KEY,
  MName   VARCHAR(20)   NOT NULL  UNIQUE,
  MPrice  INT   NOT NULL
);

create table MEDI_EFFECT (
  MID     VARCHAR(7),
  EFFECT  VARCHAR(50),
  CONSTRAINT FK_MeEf FOREIGN KEY (MID) REFERENCES MEDICATION(MID) ON DELETE CASCADE,
  PRIMARY KEY (MID, EFFECT)
);

create table Uses_Exam (
  EID_Doc   VARCHAR(7),
  PID_Out   VARCHAR(7),
  ExID      VARCHAR(7),
  MID      VARCHAR(7),
  CONSTRAINT FK_Doc     FOREIGN KEY (EID_Doc) REFERENCES DOCTOR(EID_Doc) ON DELETE CASCADE,
  CONSTRAINT FK_OutPat  FOREIGN KEY (PID_Out) REFERENCES OUTPATIENT(PID_Out) ON DELETE CASCADE,
  CONSTRAINT FK_Ex      FOREIGN KEY (ExID)    REFERENCES EXAMINATION(ExID) ON DELETE CASCADE,
  CONSTRAINT FK_Medi    FOREIGN KEY (MID)     REFERENCES MEDICATION(MID) ON DELETE CASCADE,
  PRIMARY KEY (EID_Doc, PID_Out, ExID, MID)
);
create table Uses_Treat (
  EID_Doc   VARCHAR(7),
  PID_Out   VARCHAR(7),
  TrID      VARCHAR(7),
  MID       VARCHAR(7),
  CONSTRAINT FK_Doc     FOREIGN KEY (EID_Doc) REFERENCES DOCTOR(EID_Doc) ON DELETE CASCADE,
  CONSTRAINT FK_OutPat  FOREIGN KEY (PID_Out) REFERENCES OUTPATIENT(PID_Out) ON DELETE CASCADE,
  CONSTRAINT FK_Tr      FOREIGN KEY (TrID)    REFERENCES TREATMENT(TrID) ON DELETE CASCADE,
  CONSTRAINT FK_Medi    FOREIGN KEY (MID)     REFERENCES MEDICATION(MID) ON DELETE CASCADE,
  PRIMARY KEY (EID_Doc, PID_Out, TrID, MID)
);
