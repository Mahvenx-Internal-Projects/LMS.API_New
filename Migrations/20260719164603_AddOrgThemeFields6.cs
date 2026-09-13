using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LMS.API.Migrations
{
    /// <inheritdoc />
    public partial class AddOrgThemeFields6 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Deductions",
                table: "PayrollRecords",
                newName: "TotalDeductions");

            migrationBuilder.RenameColumn(
                name: "Allowances",
                table: "PayrollRecords",
                newName: "TDS");

            migrationBuilder.AddColumn<string>(
                name: "Address",
                table: "PayrollRecords",
                type: "longtext",
                nullable: true)
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.AddColumn<decimal>(
                name: "ConveyanceAllowance",
                table: "PayrollRecords",
                type: "decimal(65,30)",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "GSTAmount",
                table: "PayrollRecords",
                type: "decimal(65,30)",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "GSTApplicable",
                table: "PayrollRecords",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<DateTime>(
                name: "JoiningDate",
                table: "PayrollRecords",
                type: "datetime(6)",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "OtherDeductions",
                table: "PayrollRecords",
                type: "decimal(65,30)",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "PFEmployee",
                table: "PayrollRecords",
                type: "decimal(65,30)",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "PFEmployer",
                table: "PayrollRecords",
                type: "decimal(65,30)",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "ProfessionTax",
                table: "PayrollRecords",
                type: "decimal(65,30)",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "SpecialAllowance",
                table: "PayrollRecords",
                type: "decimal(65,30)",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Address",
                table: "PayrollRecords");

            migrationBuilder.DropColumn(
                name: "ConveyanceAllowance",
                table: "PayrollRecords");

            migrationBuilder.DropColumn(
                name: "GSTAmount",
                table: "PayrollRecords");

            migrationBuilder.DropColumn(
                name: "GSTApplicable",
                table: "PayrollRecords");

            migrationBuilder.DropColumn(
                name: "JoiningDate",
                table: "PayrollRecords");

            migrationBuilder.DropColumn(
                name: "OtherDeductions",
                table: "PayrollRecords");

            migrationBuilder.DropColumn(
                name: "PFEmployee",
                table: "PayrollRecords");

            migrationBuilder.DropColumn(
                name: "PFEmployer",
                table: "PayrollRecords");

            migrationBuilder.DropColumn(
                name: "ProfessionTax",
                table: "PayrollRecords");

            migrationBuilder.DropColumn(
                name: "SpecialAllowance",
                table: "PayrollRecords");

            migrationBuilder.RenameColumn(
                name: "TotalDeductions",
                table: "PayrollRecords",
                newName: "Deductions");

            migrationBuilder.RenameColumn(
                name: "TDS",
                table: "PayrollRecords",
                newName: "Allowances");
        }
    }
}
