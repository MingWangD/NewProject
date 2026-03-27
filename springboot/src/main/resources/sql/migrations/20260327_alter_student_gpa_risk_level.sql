-- Upgrade script for existing databases that still use ENUM/HIGH-MEDIUM-LOW style values.
-- Run this once on the study_warning database.
USE study_warning;
ALTER TABLE student_gpa
MODIFY COLUMN risk_level VARCHAR(20) NOT NULL;
