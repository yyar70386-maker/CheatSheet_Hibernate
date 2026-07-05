-- =============================================
-- CheatSheet Report View
-- Used by JasperReports to generate CheatSheet reports
-- =============================================

CREATE OR REPLACE VIEW v_cheatsheet_report AS
SELECT 
    c.id AS cheatsheet_id,
    c.title AS cheatsheet_name,
    u.username AS created_user,
    c.created_at AS created_date,
    (SELECT COUNT(*) FROM sheet_reactions sr WHERE sr.cheatsheet_id = c.id) AS reaction_count
FROM cheatsheets c
LEFT JOIN users u ON c.author_id = u.id
WHERE c.deleted_at IS NULL
ORDER BY c.created_at DESC;
