using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LMS.API.Migrations
{
    /// <inheritdoc />
    public partial class AddLessonExamTables1 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "LessonId",
                table: "TrainingBatches",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "LessonId",
                table: "MockTests",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "LessonId",
                table: "MockTestQuestions",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_TrainingBatches_LessonId",
                table: "TrainingBatches",
                column: "LessonId");

            migrationBuilder.CreateIndex(
                name: "IX_MockTests_LessonId",
                table: "MockTests",
                column: "LessonId");

            migrationBuilder.CreateIndex(
                name: "IX_MockTestQuestions_LessonId",
                table: "MockTestQuestions",
                column: "LessonId");

            migrationBuilder.AddForeignKey(
                name: "FK_MockTestQuestions_Lessons_LessonId",
                table: "MockTestQuestions",
                column: "LessonId",
                principalTable: "Lessons",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_MockTests_Lessons_LessonId",
                table: "MockTests",
                column: "LessonId",
                principalTable: "Lessons",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_TrainingBatches_Lessons_LessonId",
                table: "TrainingBatches",
                column: "LessonId",
                principalTable: "Lessons",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_MockTestQuestions_Lessons_LessonId",
                table: "MockTestQuestions");

            migrationBuilder.DropForeignKey(
                name: "FK_MockTests_Lessons_LessonId",
                table: "MockTests");

            migrationBuilder.DropForeignKey(
                name: "FK_TrainingBatches_Lessons_LessonId",
                table: "TrainingBatches");

            migrationBuilder.DropIndex(
                name: "IX_TrainingBatches_LessonId",
                table: "TrainingBatches");

            migrationBuilder.DropIndex(
                name: "IX_MockTests_LessonId",
                table: "MockTests");

            migrationBuilder.DropIndex(
                name: "IX_MockTestQuestions_LessonId",
                table: "MockTestQuestions");

            migrationBuilder.DropColumn(
                name: "LessonId",
                table: "TrainingBatches");

            migrationBuilder.DropColumn(
                name: "LessonId",
                table: "MockTests");

            migrationBuilder.DropColumn(
                name: "LessonId",
                table: "MockTestQuestions");
        }
    }
}
