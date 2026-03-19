using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace GirafAPI.Data.Migrations
{
    /// <inheritdoc />
    public partial class UpgradeToEfCore10 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Activities_CitizenId",
                table: "Activities");

            migrationBuilder.DropIndex(
                name: "IX_Activities_GradeId",
                table: "Activities");

            migrationBuilder.DropIndex(
                name: "IX_Activities_PictogramId",
                table: "Activities");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_Activities_CitizenId",
                table: "Activities",
                column: "CitizenId");

            migrationBuilder.CreateIndex(
                name: "IX_Activities_GradeId",
                table: "Activities",
                column: "GradeId");

            migrationBuilder.CreateIndex(
                name: "IX_Activities_PictogramId",
                table: "Activities",
                column: "PictogramId");
        }
    }
}
