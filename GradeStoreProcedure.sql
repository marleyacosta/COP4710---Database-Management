/**
Maurely Acosta
COP 4710-RVC
Fall 2016
PID: 3914479
Certification: I hereby certify that this work is my own and none of it is the work of any other person. **/

DROP FUNCTION assigngrades(numeric[],text,bigint);
CREATE OR REPLACE FUNCTION assigngrades(probs numeric[], school_name text, record_id bigint) RETURNS VOID AS $$
 DECLARE
grade_distribution integer ARRAY[6];
school school_probs % ROWTYPE;
student_record simulated_records % ROWTYPE;
random_record simulated_records % ROWTYPE;
amount_of_students bigint;

BEGIN
-- Selects the row containing the school code, school name, and probs array.
SELECT * INTO school FROM school_probs WHERE school_code = record_id;
-- Selects all the records for the specific school entered.
SELECT * INTO student_record FROM simulated_records WHERE simulated_records.school= school_name;
-- Counts all the records of students for the specific school name.
SELECT COUNT(*) INTO amount_of_students FROM simulated_records WHERE simulated_records.school= school_name;

-- Get's the number of letter grades for the specific school.
grade_distribution[1] = amount_of_students * school.probs[1];
grade_distribution[2] = amount_of_students * school.probs[2];
grade_distribution[3] = amount_of_students * school.probs[3];
grade_distribution[4] = amount_of_students * school.probs[4];
grade_distribution[5] = amount_of_students * school.probs[5];
grade_distribution[6] = amount_of_students * school.probs[6];

FOR i IN 1..6 LOOP
FOR j IN 1..grade_distribution[i] LOOP

    SELECT * INTO random_record FROM simulated_records
    WHERE simulated_records.school = school_name AND grade = '-'
    ORDER BY RANDOM()
    LIMIT 1;

    IF random_record.grade = '-' THEN

	CASE
	WHEN i = 1 THEN random_record.grade = 'A';

	WHEN i = 2 THEN random_record.grade = 'A-';

	WHEN i = 3 THEN random_record.grade = 'B+';

	WHEN i = 4 THEN random_record.grade = 'B';

	WHEN i = 5 THEN random_record.grade = 'C';

	WHEN i = 6 THEN random_record.grade = 'D';

	END CASE;

    END IF;


    UPDATE simulated_records SET grade = random_record.grade WHERE simulated_records.record_id = random_record.record_id;

  END LOOP;
END LOOP;

END;

$$ LANGUAGE plpgsql;

SELECT assigngrades('{0.05,0.08,0.18,0.3,0.11,0.28}', 'CAA', 1);

 -- Display all grade records for the specific school
SELECT * FROM simulated_records WHERE school = 'CAA';

--Use this query to test if the probabilities of the grades are correct.
SELECT simulated_records.grade, count(simulated_records.grade)
FROM simulated_records
WHERE NOT grade = '-'
GROUP BY simulated_records.grade
ORDER BY simulated_records.grade;

-- Use this query to restart everything.
--UPDATE simulated_records SET grade = '-';
