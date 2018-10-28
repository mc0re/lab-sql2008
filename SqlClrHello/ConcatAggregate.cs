using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.IO;
using System.Text;
using System.Threading;
using Microsoft.SqlServer.Server;


[Serializable]
[SqlUserDefinedAggregate(Format.UserDefined, IsInvariantToDuplicates=false, IsInvariantToNulls=true, IsNullIfEmpty=true, MaxByteSize=-1)]
public class Concatenate : IBinarySerialize
{
    private List<String> mItems;


#region Aggregate methods

    public void Init()
    {
        mItems = new List<String>();
    }


    public void Accumulate(SqlString value)
    {
        if (value.IsNull) return;

        if (string.IsNullOrWhiteSpace(value.Value)) return;

        mItems.Add(string.Format("({0}) {1}", Thread.CurrentThread.ManagedThreadId, value.Value));
    }


    public void Merge(Concatenate other)
    {
        mItems.AddRange(other.mItems);
    }


    public SqlString Terminate()
    {
        if (mItems.Count == 0) return SqlString.Null;

        mItems.Sort();
        var s = mItems.Count + ": " + string.Join("; ", mItems);
        mItems.Clear();
        return s;
    }

#endregion


#region IBinarySerialize implementation

    void IBinarySerialize.Read(BinaryReader r)
    {
        mItems = new List<String>(r.ReadInt32());

        while (r.PeekChar() >= 0)
        {
            mItems.Add(r.ReadString());
        }
    }


    void IBinarySerialize.Write(BinaryWriter w)
    {
        w.Write(mItems.Count);

        foreach (var item in mItems)
        {
            w.Write(item);
        }
    }

#endregion
}
