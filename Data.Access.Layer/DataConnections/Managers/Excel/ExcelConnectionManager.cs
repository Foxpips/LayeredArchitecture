using System.Data;
using System.Data.OleDb;
using System.Linq;
using Business.Logic.Layer.Extensions;
using Business.Objects.Layer.Bases.DataAccess;

namespace Data.Access.Layer.DataConnections.Managers.Excel
{
    public class ExcelConnectionManager : DataConnectionBase
    {
        private const string Provider = "Microsoft.ACE.OLEDB.12.0;";
        private const string ExtendedProperties = "Excel 12.0 XML";
        private const string DataSource = @"C:\Users\SimonMarkey\Desktop\TestExcelData.xls";
        private readonly string _connectionString =
            string.Format("Provider={0};Extended Properties={1};Data Source={2};", Provider, ExtendedProperties,
                DataSource);

        public DataSet CreateExcelDataSet()
        {
            var ds = new DataSet();
            Connect<OleDbConnection>(_connectionString, (connection, command) =>
            {
                var dtSheet = connection.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                if (dtSheet != null)
                {
                    var pages = dtSheet.Rows.Cast<DataRow>().Select(dr => dr["TABLE_NAME"].ToString());
                    var sheets = pages.Where(sheetName => sheetName.EndsWith("$"));

                    sheets.ForEach(sheetName =>
                    {
                        command.CommandText = "SELECT * FROM [" + sheetName + "]";
                        var dt = new DataTable {TableName = sheetName};
                        new OleDbDataAdapter((OleDbCommand) command).Fill(dt);
                        ds.Tables.Add(dt);
                    });
                }
            });

            return ds;
        }

        public ExcelConnectionManager(string connectionString) : base(connectionString)
        {
        }
    }
}