/// To compile the DLL for SQL server, use this command from PowerShell:
/// . "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\Roslyn\csc.exe" /t:library /out:HelloClr.dll .\*.cs /keyfile:sqlclr.snk
///
/// To import into SQL Server, see CreateAndTest.sql.
using System.IO;
using System.Reflection;
using Microsoft.SqlServer.Server;

[assembly:AssemblyKeyFileAttribute("sqlclr.snk")]


public class Program
{
    public static void Main()
    {
        System.Console.WriteLine("Main entry point");

        ConcatAccumulateTest();
        ConcatMergeTest();
        ConcatSerializationTest();
    }


    private static void ConcatAccumulateTest()
    {
        var o = new Concatenate();
        o.Init();
        o.Accumulate("z");
        o.Accumulate("a");
        System.Console.WriteLine(o.Terminate());
    }


    private static void ConcatMergeTest()
    {
        var o1 = new Concatenate();
        o1.Init();
        o1.Accumulate("t");
        o1.Accumulate("a");

        var o2 = new Concatenate();
        o2.Init();
        o2.Accumulate("b");
        o2.Accumulate("z");

        o2.Merge(o1);
        System.Console.WriteLine(o2.Terminate());
    }


    private static void ConcatSerializationTest()
    {
        var o = new Concatenate();
        o.Init();
        o.Accumulate("z");
        o.Accumulate("a");

        var mem = new MemoryStream();
        var w = new BinaryWriter(mem);
        (o as IBinarySerialize).Write(w);
        mem.Position = 0;

        var o2 = new Concatenate();
        using (var r = new BinaryReader(mem))
        {
            (o2 as IBinarySerialize).Read(r);
        }

        o2.Accumulate("t");
        System.Console.WriteLine(o2.Terminate());
    }
}
