using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.Runtime.InteropServices;

namespace EditableOpAddIn
{
    internal class COMVariablesDisposer : IDisposable
    {
        public dynamic mObj = null;

        private bool _disposed = false;

        public COMVariablesDisposer(dynamic obj)
        {
            mObj = obj;
            _disposed = false;
        }

        public void Dispose()
        {
            DisposeClass();
            GC.SuppressFinalize(this); // Class is already disposed. Make sure destructor is never called
        }

        ~COMVariablesDisposer()
        {
            DisposeClass();
        }

        protected virtual void DisposeClass()
        {
            if (_disposed)
                return;

            if (mObj != null)
            {
                try
                {
                    Marshal.ReleaseComObject(mObj); // Release COM variable
                    mObj = null;
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.Assert(false, ex.Message);
                }
            }

            _disposed = true;
        }
    }
}
