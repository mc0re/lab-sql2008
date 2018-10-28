using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;
using Microsoft.SqlServer.Server;


public class HelloClr
{
    [SqlFunction]
    public static SqlString GetHello()
    {
        return new SqlString("Hello from SQLCLR");
    }


    [SqlProcedure]
    public static void GetProducts()
    {
        using (var cn = new SqlConnection("context connection = true"))
        {
            cn.Open();
            // var cmd = new SqlCommand(
            //     "SELECT [ProductID], [ProductName], [SupplierID], [CategoryID], [QuantityPerUnit], " +
            //     "[UnitPrice], [UnitsInStock], [UnitsOnOrder], [ReorderLevel], [Discontinued] " +
            //     "FROM [Products] ORDER BY [ProductName]", cn);
            var cmd = new SqlCommand("SELECT * FROM [Products] ORDER BY [ProductName]", cn);
            SqlContext.Pipe.ExecuteAndSend(cmd);
        }
    }


    [SqlProcedure]
    public static void GetRandom(SqlInt32 count)
    {
        var r = new SqlDataRecord(
            new SqlMetaData("RowId", SqlDbType.Int),
            new SqlMetaData("Random", SqlDbType.Int)
        );

        var rng = new Random();

        SqlContext.Pipe.SendResultsStart(r);

        for (var i = 1; i <= count; i++)
        {
            r.SetInt32(0, i);
            r.SetInt32(1, rng.Next(100));
            SqlContext.Pipe.SendResultsRow(r);
        }

        SqlContext.Pipe.SendResultsEnd();
    }


    [SqlFunction]
    public static SqlString ReadFile(SqlString fileName)
    {
        var content = File.ReadAllText(fileName.ToString());
        return content;
    }
}
