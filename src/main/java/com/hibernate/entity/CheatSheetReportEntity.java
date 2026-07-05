package com.hibernate.entity;

import lombok.Getter;
import lombok.Setter;

/**
 * Read-only entity used for CheatSheet JasperReports.
 * Fields match the .jrxml report template fields.
 */
@Getter
@Setter
public class CheatSheetReportEntity {

    private Integer no;
    private String cheatsheetName;
    private String createdUser;
    private String createdDate;
    private Long reactionCount;
}
